AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local name, setKickReason, deferrals = name, setKickReason, deferrals;
    local ipIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("Hoşgeldin %s. IP Adresiniz kontrol ediliyor.", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "ip") then
            ipIdentifier = v:sub(4)
            break
        end
    end
    Wait(0)
    if not ipIdentifier then
        deferrals.done("IP Adresinizi bulamadık.")
    else
        PerformHttpRequest("http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy", function(err, text, headers)
            if tonumber(err) == 200 then
                local tbl = json.decode(text)
                if tbl["proxy"] == false then
                    deferrals.done()
                else
                    deferrals.done("VPN kullanıyorsunuz. Lütfen devre dışı bırakın ve tekrar deneyin.")
                end
            else
                deferrals.done("API'de bir hata oluştu.")
            end
        end)
    end
end)