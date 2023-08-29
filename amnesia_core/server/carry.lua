local carrying, carried = {}, {}

local function stopCarry(source)
	local target = carrying[source] or carried[source]
	if target then
		TriggerClientEvent("coreamnesia:cl_stop", target)
		carrying[source], carrying[target] = nil, nil
		carried[source], carried[target] = nil, nil
	end
end

RegisterServerEvent("coreamnesia:sync")
AddEventHandler("coreamnesia:sync", function(targetSrc)
	local source, sourcePed = source, GetPlayerPed(source)
	if #(GetEntityCoords(sourcePed) - GetEntityCoords(GetPlayerPed(targetSrc))) <= 3.0 then 
		TriggerClientEvent("coreamnesia:syncTarget", targetSrc, source)
		carrying[source], carried[targetSrc] = targetSrc, source
	end
end)

RegisterServerEvent("coreamnesia:stop")
AddEventHandler("coreamnesia:stop", function() stopCarry(source) end)

AddEventHandler('playerDropped', function() stopCarry(source) end)