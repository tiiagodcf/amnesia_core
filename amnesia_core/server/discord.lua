CreateThread(function()
    while true do
        GlobalState.Clients = GetNumPlayerIndices()
        Wait(60000)
    end
end)