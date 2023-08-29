-- Désactiver la création aléatoire de policiers
SetCreateRandomCops(false)
SetCreateRandomCopsNotOnScenarios(false)
SetCreateRandomCopsOnScenarios(false)

-- Désactiver les camions poubelles
SetGarbageTrucks(false)

-- Désactiver les bateaux aléatoires
SetRandomBoats(false)

-- Désactiver les tirs depuis les véhicules
SetPlayerCanDoDriveBy(PlayerId(), false)

local playerPed = GetPlayerPed(-1)
SetPedConfigFlag(playerPed, 35, false)