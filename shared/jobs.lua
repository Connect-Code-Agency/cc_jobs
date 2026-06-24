Jobs = {}

Jobs.Definitions = {
    correios = {
        label = 'Correios', icon = 'fa-solid fa-box', blip = { sprite = 478, color = 5, scale = 0.8 },
        depot = vec3(78.11, 111.84, 81.17), ped = 's_m_m_postal_01', vehicle = 'boxville2',
        item = 'delivery_box', itemLabel = 'Encomenda', pay = { min = 150, max = 330 },
        description = 'Entregue encomendas por Los Santos.'
    },
    jornal = {
        label = 'Entregador de Jornal', icon = 'fa-solid fa-newspaper', blip = { sprite = 184, color = 17, scale = 0.8 },
        depot = vec3(-592.34, -929.85, 23.86), ped = 'a_m_m_business_01', vehicle = 'faggio',
        item = 'newspaper_bundle', itemLabel = 'Jornais', pay = { min = 85, max = 180 },
        description = 'Faça entregas rápidas de jornal nos bairros.'
    },
    taxi = {
        label = 'Táxi', icon = 'fa-solid fa-taxi', blip = { sprite = 198, color = 46, scale = 0.8 },
        depot = vec3(903.27, -173.95, 74.08), ped = 'a_m_y_business_02', vehicle = 'taxi',
        item = nil, pay = { min = 160, max = 380 },
        description = 'Pegue passageiros NPC e finalize corridas.'
    },
    lixeiro = {
        label = 'Coleta de Lixo', icon = 'fa-solid fa-trash', blip = { sprite = 318, color = 2, scale = 0.8 },
        depot = vec3(-322.25, -1545.87, 31.02), ped = 's_m_y_garbage', vehicle = 'trash',
        item = 'trash_bag', itemLabel = 'Saco de lixo', pay = { min = 120, max = 260 },
        description = 'Colete lixo em rotas urbanas.'
    },
    transportadora = {
        label = 'Transportadora', icon = 'fa-solid fa-truck', blip = { sprite = 477, color = 3, scale = 0.8 },
        depot = vec3(1208.86, -3115.07, 5.54), ped = 's_m_m_dockwork_01', vehicle = 'mule3',
        item = 'cargo_manifest', itemLabel = 'Manifesto de carga', pay = { min = 260, max = 620 },
        description = 'Transporte cargas entre empresas.'
    },
    jardinagem = {
        label = 'Jardinagem', icon = 'fa-solid fa-leaf', blip = { sprite = 365, color = 25, scale = 0.8 },
        depot = vec3(-1333.14, 42.83, 53.53), ped = 's_m_m_gardener_01', vehicle = 'mower',
        item = 'garden_tools', itemLabel = 'Ferramentas', pay = { min = 110, max = 240 },
        description = 'Cuide de praças e jardins.'
    },
    eletrica = {
        label = 'Companhia Elétrica', icon = 'fa-solid fa-bolt', blip = { sprite = 354, color = 5, scale = 0.8 },
        depot = vec3(724.78, 134.49, 80.96), ped = 's_m_m_lathandy_01', vehicle = 'utillitruck3',
        item = 'electric_toolkit', itemLabel = 'Kit elétrico', pay = { min = 190, max = 430 },
        description = 'Repare caixas e postes de energia.'
    },
    agua = {
        label = 'Companhia de Água', icon = 'fa-solid fa-droplet', blip = { sprite = 467, color = 3, scale = 0.8 },
        depot = vec3(454.22, -1968.45, 24.40), ped = 's_m_m_lathandy_01', vehicle = 'utillitruck2',
        item = 'pipe_repair_kit', itemLabel = 'Kit hidráulico', pay = { min = 180, max = 410 },
        description = 'Repare vazamentos e redes de água.'
    },
    agricultura = {
        label = 'Agricultura', icon = 'fa-solid fa-wheat-awn', blip = { sprite = 85, color = 25, scale = 0.8 },
        depot = vec3(2038.64, 4983.65, 41.23), ped = 'a_m_m_farmer_01', vehicle = 'tractor2',
        item = 'crop_crate', itemLabel = 'Caixa de colheita', pay = { min = 150, max = 360 },
        description = 'Plante, colha e entregue caixas agrícolas.'
    },
    pesca = {
        label = 'Pesca Profissional', icon = 'fa-solid fa-fish', blip = { sprite = 68, color = 3, scale = 0.8 },
        depot = vec3(-1598.44, 5202.69, 4.31), ped = 'a_m_m_eastsa_02', vehicle = 'dinghy',
        item = 'fish_crate', itemLabel = 'Caixa de peixes', pay = { min = 160, max = 390 },
        description = 'Pesque e entregue caixas no mercado.'
    },
    mineradora = {
        label = 'Mineradora', icon = 'fa-solid fa-helmet-safety', blip = { sprite = 618, color = 46, scale = 0.8 },
        depot = vec3(2952.57, 2747.83, 43.42), ped = 's_m_y_construct_01', vehicle = 'tiptruck',
        item = 'ore_crate', itemLabel = 'Caixa de minério', pay = { min = 190, max = 470 },
        description = 'Minere, refine e entregue recursos.'
    },
    controleanimal = {
        label = 'Controle Animal', icon = 'fa-solid fa-paw', blip = { sprite = 273, color = 31, scale = 0.8 },
        depot = vec3(562.52, 2741.21, 42.87), ped = 'a_f_y_vinewood_03', vehicle = 'bobcatxl',
        item = 'animal_crate', itemLabel = 'Caixa de transporte animal', pay = { min = 150, max = 350 },
        description = 'Resgate animais e leve ao abrigo.'
    }
}

Jobs.Routes = {
    urban = {
        vec3(285.65, -938.75, 29.35), vec3(-46.94, -1757.73, 29.42), vec3(115.53, -1462.05, 29.29),
        vec3(-711.62, -913.57, 19.22), vec3(-1222.46, -906.89, 12.33), vec3(-1487.38, -379.16, 40.16),
        vec3(-296.97, 379.88, 112.10), vec3(255.14, -1013.31, 29.27), vec3(426.86, -979.68, 30.71),
        vec3(1163.28, -323.94, 69.21), vec3(1135.63, -982.24, 46.42), vec3(24.49, -1346.66, 29.50)
    },
    industrial = {
        vec3(973.22, -2220.09, 30.55), vec3(859.25, -3202.62, 5.99), vec3(1210.19, -1260.37, 35.23),
        vec3(153.42, -3211.56, 5.91), vec3(-536.03, -1775.41, 21.49), vec3(-1056.56, -2002.02, 13.16),
        vec3(2712.87, 1578.64, 24.52), vec3(2539.35, 2594.82, 37.94)
    },
    rural = {
        vec3(1961.72, 5184.98, 47.98), vec3(1695.62, 4785.27, 41.99), vec3(2445.07, 4979.22, 46.81),
        vec3(1907.02, 4922.81, 48.86), vec3(1725.14, 4642.91, 43.88), vec3(2243.91, 5154.13, 57.88),
        vec3(2522.81, 4356.58, 39.54), vec3(2932.16, 4624.77, 48.72)
    },
    utility = {
        vec3(744.43, 129.73, 80.96), vec3(709.85, 117.15, 80.75), vec3(651.21, 101.16, 80.74),
        vec3(468.37, -1975.95, 24.73), vec3(384.83, -1990.70, 24.24), vec3(312.85, -2040.41, 20.94),
        vec3(-90.55, -1014.95, 27.28), vec3(-216.76, -1318.30, 30.89)
    },
    coast = {
        vec3(-1846.48, -1191.68, 19.18), vec3(-3427.48, 967.12, 8.35), vec3(-1605.66, 5259.78, 3.97),
        vec3(1301.09, 4224.51, 33.91), vec3(3865.86, 4463.95, 2.72), vec3(-2197.27, 4291.25, 49.17)
    }
}

Jobs.JobRouteType = {
    correios = 'urban', jornal = 'urban', taxi = 'urban', lixeiro = 'urban', transportadora = 'industrial',
    jardinagem = 'urban', eletrica = 'utility', agua = 'utility', agricultura = 'rural', pesca = 'coast',
    mineradora = 'rural', controleanimal = 'rural'
}
