Config = {}

Config.Debug = false
Config.Locale = 'pt-br'
Config.RequireJob = false -- true = exige job do Qbox igual ao jobId
Config.UseSocietyAccount = false
Config.PaymentAccount = 'cash' -- cash/bank
Config.RouteCooldownSeconds = 8
Config.MaxActiveDeliveries = 1
Config.EnableBlips = true
Config.EnableUniforms = false
Config.MRITheme = {
    primary = '#00E699',
    dark = '#020617',
    panel = '#0F172A'
}

Config.Levels = {
    [1] = 0,
    [2] = 100,
    [3] = 300,
    [4] = 650,
    [5] = 1100,
    [6] = 1750,
    [7] = 2600,
    [8] = 3700,
    [9] = 5200,
    [10] = 7000
}

Config.XP = {
    completeMin = 12,
    completeMax = 24,
    streakBonusEvery = 5,
    streakBonusXP = 20
}

Config.PayMultiplierByLevel = {
    [1] = 1.00,
    [2] = 1.05,
    [3] = 1.10,
    [4] = 1.16,
    [5] = 1.22,
    [6] = 1.30,
    [7] = 1.38,
    [8] = 1.46,
    [9] = 1.55,
    [10] = 1.65
}

Config.TargetDistance = 2.0
Config.RouteBlip = {
    sprite = 1,
    color = 2,
    scale = 0.85
}

Config.Notify = function(msg, type)
    lib.notify({
        title = 'MRI Jobs',
        description = msg,
        type = type or 'inform'
    })
end
