ESX = exports['es_extended']:getSharedObject()

local function GeneratePlate(lenght)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local nums = "0123456789"
    local plate = ""

    for i = 1, lenght do
        if i % 2 == 0 then
            plate = plate .. chars:sub(math.random(1, #chars), math.random(1, #chars))
        else
            plate = plate .. nums:sub(math.random(1, #nums), math.random(1, #nums))
        end
    end

    return plate
end

ESX.RegisterServerCallback("ERROR-GarageBuilder:Server:GetSocietyVehicles", function(source, cb, job, cartype)
    MySQL.query("SELECT * FROM owned_vehicles WHERE job = ? and type = ?", {job, cartype}, function(result)
        if result then
            cb(result)
        else
            cb({})
        end
    end)
end)

ESX.RegisterServerCallback("ERROR-GarageBuilder:Server:PayVehicle", function(source, cb, job, vehicle)
    job = ("society_%s"):format(job)
    TriggerEvent("esx_addonaccount:getSharedAccount", job, function(account)
        if account then
            if account.money >= vehicle.price then
                account.removeMoney(vehicle.price)
                cb(true)
            else
                TriggerClientEvent("esx:showNotification", source, "La société n'a pas assez d'argent pour payer le véhicule", "error")
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent("ERROR-GarageBuilder:Server:SaveVehicle", function(job, mods, cartype)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query("INSERT INTO owned_vehicles (job, plate, vehicle, type) VALUES (?, ?, ?, ?)", {job, mods.plate, json.encode(mods), cartype})
    xPlayer.showNotification("Le véhicule appartient désormais à la société", "success")
end)

ESX.RegisterServerCallback("ERROR-GarageBuilder:Server:IfVehicleOwnedBySociety", function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query("SELECT * FROM owned_vehicles WHERE job = ? and plate = ?", {xPlayer.job.name, plate}, function(result)
        if result then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent("ERROR-GarageBuilder:Server:SetVehicleState", function(plate, state, mods)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query("UPDATE owned_vehicles SET stored = ?, vehicle = ? WHERE job = ? and plate = ?", {state, json.encode(mods), xPlayer.getJob().name, plate})
end)