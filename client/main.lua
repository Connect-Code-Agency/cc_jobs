local Active = nil
local routeBlip = nil
local depotPeds = {}

local function notify(msg, type)
    if Config.Notify then Config.Notify(msg, type) end
end

RegisterNetEvent('cc_mri_jobs:notify', notify)

local function loadModel(model)
    local hash = joaat(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end
    return hash
end

local function clearRouteBlip()
    if routeBlip and DoesBlipExist(routeBlip) then RemoveBlip(routeBlip) end
    routeBlip = nil
end

local function setRouteBlip(coords, label)
    clearRouteBlip()
    routeBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(routeBlip, Config.RouteBlip.sprite)
    SetBlipColour(routeBlip, Config.RouteBlip.color)
    SetBlipScale(routeBlip, Config.RouteBlip.scale)
    SetBlipRoute(routeBlip, true)
    SetBlipRouteColour(routeBlip, Config.RouteBlip.color)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(label or 'Rota de trabalho')
    EndTextCommandSetBlipName(routeBlip)
end

local function drawMarkerAt(coords)
    DrawMarker(2, coords.x, coords.y, coords.z + 0.25, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.35, 0.35, 0.35, 0, 230, 153, 180, false, true, 2, false, nil, nil, false)
end

local function playWorkAnim(job)
    local ped = PlayerPedId()
    if job == 'jornal' then
        RequestAnimDict('anim@mp_fireworks') while not HasAnimDictLoaded('anim@mp_fireworks') do Wait(10) end
        TaskPlayAnim(ped, 'anim@mp_fireworks', 'place_firework_3_box', 4.0, -4.0, 2500, 0, 0, false, false, false)
    elseif job == 'lixeiro' then
        RequestAnimDict('anim@heists@narcotics@trash') while not HasAnimDictLoaded('anim@heists@narcotics@trash') do Wait(10) end
        TaskPlayAnim(ped, 'anim@heists@narcotics@trash', 'throw_b', 4.0, -4.0, 2500, 0, 0, false, false, false)
    else
        RequestAnimDict('mp_common') while not HasAnimDictLoaded('mp_common') do Wait(10) end
        TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 4.0, -4.0, 2500, 0, 0, false, false, false)
    end
    Wait(1800)
    ClearPedTasks(ped)
end

local function openJobMenu(job)
    local def = Jobs.Definitions[job]
    local stats = lib.callback.await('cc_mri_jobs:getStats', false, job)
    if not stats then notify('Não foi possível carregar seus dados.', 'error') return end

    lib.registerContext({
        id = 'cc_mri_jobs_' .. job,
        title = def.label,
        menu = nil,
        options = {
            {
                title = 'Iniciar rota',
                description = def.description,
                icon = def.icon,
                onSelect = function() TriggerServerEvent('cc_mri_jobs:startRoute', job) end
            },
            {
                title = ('Nível %s | XP %s/%s'):format(stats.level, stats.xp, stats.nextXp),
                description = ('Concluídos: %s | Ganhos: $%s | Sequência: %s'):format(stats.completed, stats.earned, stats.streak),
                icon = 'fa-solid fa-chart-line',
                disabled = true
            },
            {
                title = 'Ranking TOP 10',
                icon = 'fa-solid fa-trophy',
                onSelect = function()
                    local rows = lib.callback.await('cc_mri_jobs:getLeaderboard', false, job) or {}
                    local opts = {}
                    for i, row in ipairs(rows) do
                        opts[#opts+1] = {
                            title = ('#%s %s'):format(i, row.citizenid),
                            description = ('Nível %s | XP %s | Serviços %s | Ganhos $%s'):format(row.level, row.xp, row.completed, row.earned),
                            icon = 'fa-solid fa-medal', disabled = true
                        }
                    end
                    if #opts == 0 then opts[1] = { title = 'Sem dados ainda', disabled = true } end
                    lib.registerContext({ id = 'cc_mri_jobs_rank_' .. job, title = 'Ranking - ' .. def.label, menu = 'cc_mri_jobs_' .. job, options = opts })
                    lib.showContext('cc_mri_jobs_rank_' .. job)
                end
            },
            {
                title = 'Cancelar rota ativa',
                icon = 'fa-solid fa-ban',
                onSelect = function() TriggerServerEvent('cc_mri_jobs:cancelRoute') clearRouteBlip() Active = nil end
            }
        }
    })

    lib.showContext('cc_mri_jobs_' .. job)
end

local function createDepot(job, def)
    local hash = loadModel(def.ped or 's_m_m_postal_01')
    local ped = CreatePed(0, hash, def.depot.x, def.depot.y, def.depot.z - 1.0, 0.0, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    depotPeds[#depotPeds+1] = ped

    exports.ox_target:addLocalEntity(ped, {
        {
            label = 'Abrir ' .. def.label,
            icon = def.icon,
            distance = Config.TargetDistance,
            onSelect = function() openJobMenu(job) end
        }
    })

    if Config.EnableBlips then
        local blip = AddBlipForCoord(def.depot.x, def.depot.y, def.depot.z)
        SetBlipSprite(blip, def.blip.sprite)
        SetBlipColour(blip, def.blip.color)
        SetBlipScale(blip, def.blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(def.label)
        EndTextCommandSetBlipName(blip)
    end
end

RegisterNetEvent('cc_mri_jobs:routeStarted', function(job, coords)
    local def = Jobs.Definitions[job]
    Active = { job = job, coords = coords }
    setRouteBlip(coords, def.label .. ' - destino')
    notify(('Rota iniciada: %s. Vá até o ponto marcado no GPS.'):format(def.label), 'success')
end)

RegisterNetEvent('cc_mri_jobs:routeFinished', function(job, pay, xp, leveled, level)
    clearRouteBlip()
    Active = nil
    local msg = ('Serviço concluído. Recebeu $%s e %s XP.'):format(pay, xp)
    if leveled then msg = msg .. (' Subiu para o nível %s!'):format(level) end
    notify(msg, 'success')
end)

CreateThread(function()
    Wait(1000)
    for job, def in pairs(Jobs.Definitions) do createDepot(job, def) end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if Active then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local dist = #(coords - Active.coords)
            if dist < 35.0 then
                sleep = 0
                drawMarkerAt(Active.coords)
                if dist < 2.0 then
                    lib.showTextUI('[E] Finalizar serviço')
                    if IsControlJustPressed(0, 38) then
                        lib.hideTextUI()
                        if lib.progressCircle({ duration = 2800, label = 'Finalizando serviço...', position = 'bottom', useWhileDead = false, canCancel = true, disable = { car = true, move = true, combat = true } }) then
                            playWorkAnim(Active.job)
                            TriggerServerEvent('cc_mri_jobs:finishRoute', Active.job)
                        end
                    end
                else
                    lib.hideTextUI()
                end
            else
                lib.hideTextUI()
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearRouteBlip()
    for _, ped in ipairs(depotPeds) do if DoesEntityExist(ped) then DeleteEntity(ped) end end
    lib.hideTextUI()
end)
