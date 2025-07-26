ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

for job, list in pairs(Config.garages) do
    for i,jobData in pairs(list) do
        local npc = CreatePNJ(jobData.ped, jobData.position.x, jobData.position.y, jobData.position.z, jobData.position.w)

        exports.ox_target:addLocalEntity(npc, {
            {
                label = "Acceder au garage",
                icon = "fas fa-car",
                event = "ERROR-GarageBuilder:Client:OpenGarage",
                job = job,
                spawn = jobData.spawn,
                filter = jobData.filter,
                distance = 1.5,
                canInteract = function(entity, distance, coords, name, bone)
                    return ESX.PlayerData.job and ESX.PlayerData.job.name == job
                end,
        
            },
            {
                label = "Ranger le véhicule",
                icon = "fas fa-warehouse",
                job = job,
                distance = 1.5,
                canInteract = function(entity, distance, coords, name, bone)
                    return ESX.PlayerData.job and ESX.PlayerData.job.name == job
                end,
    
                onSelect = function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    
                    if (not DoesEntityExist(vehicle)) then
                        ESX.ShowNotification("Aucun véhicule", "error")
                        return
                    end

                    local plate = GetVehicleNumberPlateText(vehicle)
    
                    ESX.TriggerServerCallback("ERROR-GarageBuilder:Server:IfVehicleOwnedBySociety", function(owned) 
                        if (not owned) then
                            ESX.ShowNotification("Ce véhicule n'appartient pas à la société", "error")
                            return
                        end
                        TriggerServerEvent("ERROR-GarageBuilder:Server:SetVehicleState", plate, 1, ESX.Game.GetVehicleProperties(vehicle))
                        Config.RemoveKeys(vehicle)
                        DeleteEntity(vehicle)
                    end, plate)
                end,
        
            },
        })
    end

end

local npc = CreatePNJ(Config.Shop.ped, Config.Shop.location.x, Config.Shop.location.y, Config.Shop.location.z, Config.Shop.location.w)
exports.ox_target:addLocalEntity(npc, {
    label = "Acceder au shop",
    icon = "fas fa-car",
    event = "ERROR-GarageBuilder:Client:OpenShop",
    interactDist = 1.5,
    canInteract = function(entity, distance, coords, name, bone)
        return ESX.PlayerData.job.grade_name == "boss" and Config.Shop.vehicles[ESX.PlayerData.job.name]
    end,
})

RegisterNetEvent("ERROR-GarageBuilder:Client:OpenGarage", function(data)
    ESX.TriggerServerCallback("ERROR-GarageBuilder:Server:GetSocietyVehicles", function(resp)
        local vehicles = {}

        for k, vehicle in pairs(resp) do
            local vehicleData = json.decode(vehicle.vehicle)
            vehicles[#vehicles + 1] = {
                title = ("[%s] %s"):format(vehicleData.plate, GetDisplayNameFromVehicleModel(vehicleData.model)),
                description = ("Plaque: %s"):format(vehicleData.plate),
                disabled = vehicle.stored == 0,
                onSelect = function()
                    local vehicle = CreateCar(vehicleData.model, data.spawn.x, data.spawn.y, data.spawn.z, data.spawn.w)
                    ESX.Game.SetVehicleProperties(vehicle, vehicleData)
                    TriggerServerEvent("ERROR-GarageBuilder:Server:SetVehicleState", GetVehicleNumberPlateText(vehicle), 0)
                    Config.GiveKeys(vehicle)
                end
            }
        end

        lib.registerContext({
            id = ("garage_%s"):format(data.job),
            title = ("Garage %s"):format(data.job),
            options = vehicles,
        })
        lib.showContext(("garage_%s"):format(data.job))
    end, ESX.PlayerData.job.name, data.filter)
end)

RegisterNetEvent("ERROR-GarageBuilder:Client:OpenShop", function(data)
    local vehicles_table = Config.Shop.vehicles[ESX.PlayerData.job.name]
    local vehicles = {}
    for k,v in pairs(vehicles_table) do
        vehicles[#vehicles + 1] = {
            title = v.label,
            description = ("Prix: %s"):format(v.price),
            onSelect = function()
                ESX.TriggerServerCallback("ERROR-GarageBuilder:Server:PayVehicle", function(resp) 
                    if (not resp) then
                        ESX.ShowNotification("Vous n'avez pas assez d'argent", "error")
                        return
                    end

                    local vehicle = CreateCar(v.model, Config.Shop.spawn.x, Config.Shop.spawn.y, Config.Shop.spawn.z, Config.Shop.spawn.w)
                    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    local plate = GetVehicleNumberPlateText(vehicle)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    print(plate, model)
                    exports['qs-vehiclekeys']:GiveKeys(plate, model, true)
                    TriggerServerEvent("ERROR-GarageBuilder:Server:SaveVehicle", ESX.PlayerData.job.name, ESX.Game.GetVehicleProperties(vehicle), v.type)
                end, ESX.PlayerData.job.name, {
                    price = v.price,
                })
            end
        }
    end

    lib.registerContext({
        id = "shop",
        title = "Boutique véhicules entreprise",
        options = vehicles,
    })
    lib.showContext("shop")
end)