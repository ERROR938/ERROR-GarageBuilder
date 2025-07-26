Config = {}

Config.GiveKeys = function(vehicle)
    if (GetResourceState("qs-vehiclekeys") == "started") then
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local plate = GetVehicleNumberPlateText(vehicle)
        exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
    end
end

Config.RemoveKeys = function(vehicle)
    if (GetResourceState("qs-vehiclekeys") == "started") then
        local plate = GetVehicleNumberPlateText(vehicle)
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        exports['qs-vehiclekeys']:RemoveKeys(plate, model)
    end
end

Config.garages = {
    ['fermier'] = {
        {
            filter = "helicopter",
            position = vec4(-334.9104, -260.9521, 43.2367, 232.0862),
            spawn = vec4(-326.7565, -270.8874, 43.1414, 235.2273),
            ped = "s_m_y_cop_01",
        },
        {
            filter = "car",
            position = vec4(-327.9296, -267.2944, 28.0673, 136.1363),
            spawn = vec4(-321.0579, -268.0261, 27.4253, 143.6510),
            ped = "s_m_y_dockwork_01",
        },
    },
}

Config.Shop = {
    location = vec4(558.9724, -252.4192, 49.9806, 40.2113),
    ped = "s_m_y_casino_01",
    spawn = vec4(545.7001, -277.5385, 49.6311, 19.8302),
    vehicles = {
        ['fermier'] = {
            {label = "Police 1", model = "police", price = 70000, type = "car"},
            {label = "Police 2", model = "police2", price = 20000, type = "car"},
            {label = "Bus police", model = "pbus", price = 20000, type = "car"},
            {label = "Hélicoptere", model = "polmav", price = 500000, type = "helicopter"},
        },
    }
}

-- Lien vers la doc : https://error-scripts.gitbook.io/job-garages