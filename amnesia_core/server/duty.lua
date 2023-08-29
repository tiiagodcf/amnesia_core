local jobs = {}

local function setPlayerDuty(source, jobName, set)
	local job = jobs[jobName]

	if job then
		if set and not job.playerList[source] then
			job.playerList[source] = true
			job.playerCount += 1

			if job.playerCount == 1 then
				TriggerClientEvent('okokNotify:Alert', -1, job.label, 'Vient d\'ouvrir ses portes.', 3500, 'success', false)
			end
		elseif not set and job.playerList[source] then
			job.playerList[source] = nil
			job.playerCount -= 1

			if job.playerCount == 0 then
				TriggerClientEvent('okokNotify:Alert', -1, job.label, 'Vient de fermer ses portes.', 3500, 'error', false)
			end
		end
	end
end

RegisterNetEvent('amnesia_core:toggleDuty', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local jobName = xPlayer.job.name
		local isOnDuty = not string.match(jobName, 'off')

		if not isOnDuty then
			jobName = jobName:gsub('off', '')
		end

		local job = jobs[jobName]

		if job then
			xPlayer.setJob((isOnDuty and 'off'..jobName or jobName), xPlayer.job.grade)
			lib.notify(xPlayer.source, {
                title = (isOnDuty and 'Hors service' or 'En service'),
                description = (isOnDuty and 'Vous venez de quitter votre service!' or 'Vous venez de prendre votre service!'),
                type = 'inform'
            })
		end
	end
end)

AddEventHandler('esx:setJob', function(source, newJob, lastJob)
	if lastJob and jobs[lastJob.name] then
		setPlayerDuty(source, lastJob.name, false)
	end

	if newJob and jobs[newJob.name] then
		setPlayerDuty(source, newJob.name, true)
	end
end)

AddEventHandler('esx:playerDropped', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playerJob = xPlayer.job
		local job = jobs[playerJob.name]

		if job then
			setPlayerDuty(source, playerJob.name, false)
			xPlayer.setJob(('off%s'):format(playerJob.name), playerJob.grade)
			MySQL.prepare('UPDATE `users` SET `previous_job` = ?, `previous_job_grade` = ? WHERE `identifier` = ?', {
				playerJob.name,
				playerJob.grade,
				xPlayer.identifier
			})
		end
	end
end)

CreateThread(function()
	for i = 1, #Config.Duties do
		local duty = Config.Duties[i]

		jobs[duty.name] = {
			label = duty.label,
			playerList = {},
			playerCount = 0
		}
	end

	Config.Duties = nil
end)
