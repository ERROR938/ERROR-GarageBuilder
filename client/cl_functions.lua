function CreatePNJ(model, x, y, z, h)
    local pedHash = GetHashKey(model)
    RequestModel(pedHash)

    while not HasModelLoaded(pedHash) do
        Wait(1)
    end

    local ped = CreatePed(4, pedHash, x, y, z-1, h, false, true)
    SetEntityAsMissionEntity(ped, true, false)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetPedDefaultComponentVariation(ped)
    return ped
end

function CreateCar(model, x, y, z, h)
    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(1)
    end

    local car = CreateVehicle(model, x, y, z, h, true, false)
    SetVehicleOnGroundProperly(car)
    SetEntityAsMissionEntity(car, true, true)
    SetVehicleHasBeenOwnedByPlayer(car, true)
    -- SetModelAsNoLongerNeeded(carHash)
    return car
end