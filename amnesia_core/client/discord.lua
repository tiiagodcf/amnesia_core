do
    SetDiscordAppId('971539618145140736')
    SetDiscordRichPresenceAsset('img_6409')
    SetDiscordRichPresenceAssetText(('Amnesia - ID #%s'):format(GetPlayerServerId(PlayerId())))
    SetDiscordRichPresenceAction(0, 'Rejoindre', 'fivem://connect/play.amnesiafivem.fr')
    SetDiscordRichPresenceAction(1, 'Discord', 'https://discord.gg/amnesiafivem')

    local clients = GlobalState.Clients or 0
    SetRichPresence(('%s joueur%s en ligne.'):format(clients, (clients > 1 and 's' or '')))
end

AddStateBagChangeHandler('Clients', 'global', function(_, _, value)
    SetRichPresence(('%s joueur%s en ligne.'):format(value, (value > 1 and 's' or '')))
end)