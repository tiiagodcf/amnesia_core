RegisterCommand("wipe", function(source, args, rawCommand)
    local src = source
    local targetID = tonumber(args[1])
    if targetID then
        local xPlayer = ESX.GetPlayerFromId(targetID)
        if xPlayer then
            DropPlayer(targetID, "Vous avez été wipe par un admin.")
            Wait(5000)

            -- Supprimer les licences de l'utilisateur
            MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner', {
                ['@owner'] = xPlayer.identifier
            })

            -- Supprimer les données de l'utilisateur
            MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            })

            -- Supprimer les véhicules de l'utilisateur
            MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @owner', {
                ['@owner'] = xPlayer.identifier
            })

            -- Supprimer les stats de gym de l'utilisateur
            MySQL.Async.execute('DELETE FROM gymstats WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            })

            -- Supprimer les jobs de l'utilisateur
            MySQL.Async.execute('DELETE FROM user_jobs WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            })

            -- Supprimer le datastore de l'utilisateur
            MySQL.Async.execute('DELETE FROM datastore_data WHERE owner = @owner', {
                ['@owner'] = xPlayer.identifier
            })

            -- Kicker le joueur
        else
            TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "Joueur non trouvé!")
        end
    else
        TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "Vous devez spécifier un ID!")
    end
end, true)  -- Le "false" indique que cette commande est pour les admins seulement.