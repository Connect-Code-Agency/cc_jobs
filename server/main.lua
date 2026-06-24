local Core = exports.qbx_core
local ActiveRoutes = {}
local LastAction = {}

local function dbg(...)
    if Config.Debug then print('[cc_mri_jobs]', ...) end
end

local function getPlayer(src)
    if Core and Core.GetPlayer then return Core:GetPlayer(src) end
    return nil
end

local function getCitizenId(src)
    local Player = getPlayer(src)
    if not Player then return nil end
    if Player.PlayerData and Player.PlayerData.citizenid then return Player.PlayerData.citizenid end
    if Player.citizenid then return Player.citizenid end
    return nil
end

local function getJobName(src)
    local Player = getPlayer(src)
    if not Player then return nil end
    local job = Player.PlayerData and Player.PlayerData.job
    if type(job) == 'table' then return job.name end
    return job
end

local function addMoney(src, account, amount, reason)
    local Player = getPlayer(src)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    if Player and Player.Functions and Player.Functions.AddMoney then
        return Player.Functions.AddMoney(account or 'cash', amount, reason or 'cc_mri_jobs')
    end
    exports.ox_inventory:AddItem(src, 'money', amount)
    return true
end

local function addItem(src, item, count)
    if not item then return true end
    return exports.ox_inventory:AddItem(src, item, count or 1)
end

local function removeItem(src, item, count)
    if not item then return true end
    local invCount = exports.ox_inventory:Search(src, 'count', item) or 0
    if invCount < (count or 1) then return false end
    exports.ox_inventory:RemoveItem(src, item, count or 1)
    return true
end

local function ensureProgress(citizenid, job)
    MySQL.insert.await([[INSERT IGNORE INTO cc_job_progress (citizenid, job, level, xp, completed, earned, streak)
        VALUES (?, ?, 1, 0, 0, 0, 0)]], { citizenid, job })
    return MySQL.single.await('SELECT * FROM cc_job_progress WHERE citizenid = ? AND job = ?', { citizenid, job })
end

local function calcLevel(xp)
    local level = 1
    for lvl, need in pairs(Config.Levels) do
        if xp >= need and lvl > level then level = lvl end
    end
    return level
end

local function nextLevelXP(level)
    return Config.Levels[level + 1] or Config.Levels[level] or 0
end

local function canAct(src)
    local now = os.time()
    if LastAction[src] and (now - LastAction[src]) < Config.RouteCooldownSeconds then return false end
    LastAction[src] = now
    return true
end

lib.callback.register('cc_mri_jobs:getStats', function(src, job)
    local citizenid = getCitizenId(src)
    if not citizenid or not Jobs.Definitions[job] then return nil end
    local row = ensureProgress(citizenid, job)
    local xp = row and row.xp or 0
    local level = calcLevel(xp)
    return {
        job = job,
        label = Jobs.Definitions[job].label,
        level = level,
        xp = xp,
        nextXp = nextLevelXP(level),
        completed = row and row.completed or 0,
        earned = row and row.earned or 0,
        streak = row and row.streak or 0
    }
end)

lib.callback.register('cc_mri_jobs:getLeaderboard', function(src, job)
    if not Jobs.Definitions[job] then return {} end
    local rows = MySQL.query.await([[SELECT citizenid, level, xp, completed, earned FROM cc_job_progress
        WHERE job = ? ORDER BY xp DESC, completed DESC LIMIT 10]], { job })
    return rows or {}
end)

RegisterNetEvent('cc_mri_jobs:startRoute', function(job)
    local src = source
    if not canAct(src) then return end
    local def = Jobs.Definitions[job]
    if not def then return end

    if Config.RequireJob and getJobName(src) ~= job then
        TriggerClientEvent('cc_mri_jobs:notify', src, 'Você não possui esse emprego.', 'error')
        return
    end

    if ActiveRoutes[src] then
        TriggerClientEvent('cc_mri_jobs:notify', src, 'Você já possui uma rota ativa.', 'error')
        return
    end

    local citizenid = getCitizenId(src)
    if not citizenid then return end
    local progress = ensureProgress(citizenid, job)
    local routeType = Jobs.JobRouteType[job] or 'urban'
    local list = Jobs.Routes[routeType]
    local destination = list[math.random(1, #list)]

    ActiveRoutes[src] = {
        job = job,
        destination = destination,
        started = os.time(),
        level = calcLevel(progress.xp or 0)
    }

    if def.item then addItem(src, def.item, 1) end
    TriggerClientEvent('cc_mri_jobs:routeStarted', src, job, destination)
end)

RegisterNetEvent('cc_mri_jobs:finishRoute', function(job)
    local src = source
    if not canAct(src) then return end
    local active = ActiveRoutes[src]
    local def = Jobs.Definitions[job]
    if not active or active.job ~= job or not def then
        TriggerClientEvent('cc_mri_jobs:notify', src, 'Você não tem rota ativa desse emprego.', 'error')
        return
    end

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    if #(coords - active.destination) > 12.0 then
        TriggerClientEvent('cc_mri_jobs:notify', src, 'Você está longe do ponto de serviço.', 'error')
        return
    end

    if def.item and not removeItem(src, def.item, 1) then
        TriggerClientEvent('cc_mri_jobs:notify', src, ('Você precisa de: %s.'):format(def.itemLabel or def.item), 'error')
        return
    end

    local citizenid = getCitizenId(src)
    if not citizenid then return end
    local row = ensureProgress(citizenid, job)
    local currentXP = row.xp or 0
    local level = calcLevel(currentXP)
    local mult = Config.PayMultiplierByLevel[level] or 1.0
    local pay = math.floor(math.random(def.pay.min, def.pay.max) * mult)
    local xp = math.random(Config.XP.completeMin, Config.XP.completeMax)
    local streak = (row.streak or 0) + 1
    if Config.XP.streakBonusEvery > 0 and streak % Config.XP.streakBonusEvery == 0 then
        xp = xp + Config.XP.streakBonusXP
        pay = math.floor(pay * 1.12)
    end

    local newXP = currentXP + xp
    local newLevel = calcLevel(newXP)

    addMoney(src, Config.PaymentAccount, pay, 'cc_mri_jobs_' .. job)
    MySQL.update.await([[UPDATE cc_job_progress SET xp = ?, level = ?, completed = completed + 1,
        earned = earned + ?, streak = ?, updated_at = CURRENT_TIMESTAMP WHERE citizenid = ? AND job = ?]],
        { newXP, newLevel, pay, streak, citizenid, job })

    ActiveRoutes[src] = nil
    TriggerClientEvent('cc_mri_jobs:routeFinished', src, job, pay, xp, newLevel > level, newLevel)
end)

RegisterNetEvent('cc_mri_jobs:cancelRoute', function()
    local src = source
    local active = ActiveRoutes[src]
    if not active then return end
    local def = Jobs.Definitions[active.job]
    if def and def.item then removeItem(src, def.item, 1) end
    ActiveRoutes[src] = nil
    TriggerClientEvent('cc_mri_jobs:notify', src, 'Rota cancelada.', 'inform')
end)

AddEventHandler('playerDropped', function()
    ActiveRoutes[source] = nil
    LastAction[source] = nil
end)
