local carry = {
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

local function drawNativeNotification(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function getClosestPlayer(radius)
	local players, playerPed, playerCoords = GetActivePlayers(), PlayerPedId(), GetEntityCoords(PlayerPedId())
	local closestPlayer, closestDistance = -1, -1

	for _,playerId in ipairs(players) do
		local targetPed = GetPlayerPed(playerId)
		if targetPed ~= playerPed then
			local distance = #(GetEntityCoords(targetPed) - playerCoords)
			if closestDistance == -1 or closestDistance > distance then
				closestPlayer, closestDistance = playerId, distance
			end
		end
	end

	return closestDistance ~= -1 and closestDistance <= radius and closestPlayer or nil
end

local function ensureAnimDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do Wait(0) end        
	end
end

RegisterCommand("carry", function()
	if carry.InProgress then
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("coreamnesia:stop", carry.targetSrc)
		carry.targetSrc = 0
	else
		local closestPlayer = getClosestPlayer(3)
		if closestPlayer then
			carry.InProgress, carry.targetSrc = true, GetPlayerServerId(closestPlayer)
			TriggerServerEvent("coreamnesia:sync", carry.targetSrc)
			ensureAnimDict(carry.personCarrying.animDict)
			carry.type = "carrying"
		else
			exports['okokNotify']:Alert('', 'Personne à proximité ', 3000, 'error', false)
		end
	end
end, false)

RegisterNetEvent("coreamnesia:syncTarget")
AddEventHandler("coreamnesia:syncTarget", function(targetSrc)
	carry.InProgress, carry.type = true, "beingcarried"
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	ensureAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
end)

RegisterNetEvent("coreamnesia:cl_stop")
AddEventHandler("coreamnesia:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if carry.InProgress then
			local person = carry.type == "beingcarried" and carry.personCarried or carry.personCarrying
			if not IsEntityPlayingAnim(PlayerPedId(), person.animDict, person.anim, 3) then
				TaskPlayAnim(PlayerPedId(), person.animDict, person.anim, 8.0, -8.0, 100000, person.flag, 0, false, false, false)
			end
		end
		Wait(0)
	end
end)