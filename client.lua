config = {
    dist = 5, -- Distance between player to show id
    idScale = 2, -- Scale of id text
    zOffset = 0.5 -- How high above id should be on player
}

local show = false

RegisterCommand("+showids", function()
    show = true
    CreateThread(function()
        while show do
            Wait(0)
            local ply = PlayerPedId()
            local plyCoord = GetEntityCoords(ply)
            for _, id in ipairs(GetActivePlayers()) do
                local otherPly = GetPlayerPed(id)
                local otherCoord = GetEntityCoords(otherPly)
                if (#(plyCoord - otherCoord) <= config.dist) then
                    local pos = GetPedBoneCoords(otherPly, 31086, 0, 0, 0)
                    local getId = GetPlayerServerId(id)
                    DrawText3D(pos, getId, 255, 255, 255)
                end
            end
        end
    end)
end)
RegisterCommand("-showids", function()
    show = false
end)

RegisterKeyMapping("+showids", "(Hold) Show ID's Over Head", "keyboard", "GRAVE")

function DrawText3D(position, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(position.x, position.y, position.z + config.zOffset)
    local dist = #(GetGameplayCamCoords() - position)

    local scale = (1 / dist) * config.idScale
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0 * scale, 0.55 * scale)
        else
            SetTextScale(0.0 * scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
