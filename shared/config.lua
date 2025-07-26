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
        -- { POUR EXEMPLE
        --     filter = "helicopter",
        --     position = vec4(-334.9104, -260.9521, 43.2367, 232.0862),
        --     spawn = vec4(-326.7565, -270.8874, 43.1414, 235.2273),
        --     ped = "s_m_y_cop_01",
        -- },
        {
            filter = "car",
            position = vec4(-28.8285, -1157.2192, 26.8673, 3.7609),
            spawn = vec4(-32.8310, -1148.9210, 26.5033, 92.3379),
            ped = "s_m_y_dockwork_01",
        },
    },
}

Config.Shop = {
    location = vec4(-56.7076, -1098.6287, 26.4224, 31.7129),
    ped = "s_m_y_casino_01",
    spawn = vec4(-12.3505, -1083.3850, 26.6721, 245.4047),
    vehicles = {
        ['fermier'] = {
            {label = "Burrito", model = "burrito", price = 500, type = "car"},
            {label = "Burrito2", model = "burrito2", price = 20000, type = "car"},
            {label = "Hélicoptere", model = "polmav", price = 200, type = "helicopter"},
        },
    }
}

-- Lien vers la doc : https://error-scripts.gitbook.io/job-garages