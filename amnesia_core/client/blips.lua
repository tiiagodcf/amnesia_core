Citizen.CreateThread(function()
    local blips = {
        {coords = vector3(-1004.7065, -270.2711, 39.0396), sprite = 614, colour = 50, scale = 0.8, name = "Studio de musique"},
        {coords = vector3(340.6945, 198.3725, 103.0325), sprite = 135, colour = 16, scale = 0.7, name = "Cinéma"},
        {coords = vector3(-586.0350, -926.1323, 23.8777), sprite = 590, colour = 76, scale = 0.7, name = "Weazel News"},
        {coords = vector3(-705.6131, 269.4768, 83.1473), sprite = 476, colour = 70, scale = 0.8, name = "Dynasty - Agence Immobilière"},
        {coords = vector3(72.6000, -1779.6841, 29.6171), sprite = 628, colour = 5, scale = 0.7, name = "SuperMarket"},
    }
    for _, blipInfo in ipairs(blips) do
        local blip = AddBlipForCoord(blipInfo.coords.x, blipInfo.coords.y, blipInfo.coords.z)
        SetBlipSprite(blip, blipInfo.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, blipInfo.scale)
        SetBlipColour(blip, blipInfo.colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipInfo.name)
        EndTextCommandSetBlipName(blip)
    end
end)