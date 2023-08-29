CreateThread(function()
	for i = 1, #Config.Duties do
		local duty = Config.Duties[i]

		if duty.target then
			exports.ox_target:addSphereZone({
				coords = duty.target.coords,
				radius = duty.target.radius,
				debug = false,
				drawSprite = false,
				options = {
                    {
                        label = 'Prendre/Retirer service',
                        groups = { duty.name, 'off'..duty.name },
                        serverEvent = 'amnesia_core:toggleDuty'
                    }
                }
			})
		end
	end
end)
