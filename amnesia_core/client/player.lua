ESX = exports["es_extended"]:getSharedObject()

-- Densité PNJ
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetPedDensityMultiplierThisFrame(0.3)
        SetVehicleDensityMultiplierThisFrame(0.3)
        SetParkedVehicleDensityMultiplierThisFrame(0.1)
        SetRandomVehicleDensityMultiplierThisFrame(0.3)
        SetScenarioPedDensityMultiplierThisFrame(0.0)
    end
end)

-- Control Aérien 

local wasInVehicle = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4000)

        local playerPed = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(playerPed, false)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local driver = GetPedInVehicleSeat(vehicle, -1)

        if isInVehicle and not wasInVehicle and driver == playerPed then
            wasInVehicle = true
            Citizen.CreateThread(checkAirControl)
        elseif not isInVehicle and wasInVehicle then
            wasInVehicle = false
        end
    end
end)

function checkAirControl()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    while IsPedInVehicle(playerPed, vehicle, false) do
        Citizen.Wait(0)

        if IsEntityInAir(vehicle) then
            DisableControlAction(0, 59)
            DisableControlAction(0, 60)
        end
    end
end

-- Animation blessure selon santé  

local hurt = false
local screenEffectActive = false
local playerPed
local prevHealth
local screenEffect = "BeastLaunch"

Citizen.CreateThread(function()
    while true do
        playerPed = GetPlayerPed(-1)
        prevHealth = GetEntityHealth(playerPed)
        Citizen.Wait(3500)
        local curHealth = GetEntityHealth(playerPed)
        
        if curHealth <= 130 then
            if not hurt or curHealth ~= prevHealth then
                setHurt()
            end
        elseif hurt and curHealth > 130 then
            setNotHurt()
        end

        if curHealth <= 120 and not screenEffectActive then
            StartScreenEffect(screenEffect, 0, true)
            screenEffectActive = true
        elseif screenEffectActive and curHealth > 110 then
            StopScreenEffect(screenEffect)
            screenEffectActive = false
        end

        prevHealth = curHealth
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hurt then
            DisableControlAction(0, 21, true) -- disable run
            DisableControlAction(0, 22, true) -- disable jump
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(9000) -- Vérifie toutes les 9 secondes
        if hurt then
            local currentAnimSet = GetEntityAnimCurrentTime(playerPed)
            if currentAnimSet ~= "move_m@injured" then
                setHurt() -- Rétablir l'ensemble d'animations de blessure
            end
        end
    end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    while not HasAnimSetLoaded("move_m@injured") do
        Citizen.Wait(0)
    end
    SetPedMovementClipset(playerPed, "move_m@injured", true)
end

function setNotHurt()
    hurt = false
    ResetPedMovementClipset(playerPed)
    ResetPedWeaponMovementClipset(playerPed)
    ResetPedStrafeClipset(playerPed)
end
 -- Rockstar Editor

RegisterCommand('recordstart', function()
	StartRecording(1)
end, false)

RegisterCommand('recordstop', function()
	StopRecordingAndSaveClip()
end, false)

RegisterCommand('recorddiscard', function()
	StopRecordingAndDiscardClip()
end, false)

RegisterCommand('rockstareditor', function()
	NetworkSessionLeaveSinglePlayer()
	ActivateRockstarEditor()
end, false)
