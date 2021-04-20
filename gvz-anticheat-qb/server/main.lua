PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({
    ['username'] = Config.WebhookName,
    ['avatar_url'] = Config.WebhookAvatarUrl,
    ['embeds'] = {{
        ['author'] = {
            ['name'] = 'G3VEZE ANTİCHEAT',
            ['icon_url'] = 'https://cdn.discordapp.com/attachments/785071461516836874/802859048495349770/G3VEZE.png'
        },
        ['footer'] = {
            ['text'] = 'gvz-anticheat 1.2'
        },
        ['color'] = 12914,
        ['description'] = 'Anticheat Başlatıldı',
        ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }}
}), {['Content-Type'] = 'application/json' })


AddEventHandler('entityCreated', function(entity)
    if DoesEntityExist(entity) then
        if GetEntityType(entity) == 3 then
            for _, blacklistedProps in pairs(Config.BlacklistProps) do
                if GetEntityModel(entity) == GetHashKey(blacklistedProps) then
                    local src = NetworkGetEntityOwner(entity)
                    local xPlayer = QBCore.Functions.GetPlayer(source)
                    if Config.AntiPropLog then
                        dclog(xPlayer, 'Blacklistli Prop Çıkartıldı Prop: '..blacklistedProps..'\n**Prop:** https://plebmasters.de/?search='..blacklistedProps..'&app=objects \n**Google:** https://www.google.com/search?q='..blacklistedProps..' \n **Mwojtasik:** https://mwojtasik.dev/tools/gtav/objects/search?name='..blacklistedProps)
                    end
                    if Config.AntiPropDrop then
                        xPlayer.kick(Config.KickMessage)
                    end
                    TriggerClientEvent('gvz-anticheat:antiProp', -1)
                    CancelEvent()
                    return
                end
            end
        elseif GetEntityType(entity) == 2 then
            for _, blacklistedVeh in pairs(Config.BlacklistVehicles) do
                if GetEntityModel(entity) == GetHashKey(blacklistedVeh) then
                    local src = NetworkGetEntityOwner(entity)
                    local xPlayer = QBCore.Functions.GetPlayer(source)
                    if Config.AntiVehLog then
                        dclog(xPlayer, 'Yasaklanan Araç Spawnlandı: '..blacklistedVeh..'\n **Çıkarmaya Çalıştığı araç:** https://www.gtabase.com/search?searchword='..blacklistedVeh)
                    end
                    if Config.AntiVehDrop then
                        xPlayer.kick(Config.KickMessage)
                    end
                    TriggerClientEvent('gvz-anticheat:AntiVehicle', -1)
                    CancelEvent()
                    return
                end
            end
        elseif GetEntityType(entity) == 1 then
            for _, blacklistedPed in pairs(Config.BlacklistPeds) do
                if GetEntityModel(entity) == GetHashKey(blacklistedPed) then
                    local src = NetworkGetEntityOwner(entity)
                    local xPlayer = QBCore.Functions.GetPlayer(source)
                    if Config.AntiPedLog then
                        dclog(xPlayer, 'Yasaklanan Ped Spawnlandı Pedin adı: '..blacklistedPed..'\n **Pedin Resmi:** https://docs.fivem.net/peds/'..blacklistedPed..'.png')
                    end
                    if Config.AntiPedDrop then
                        xPlayer.kick(Config.KickMessage)
                    end
                    TriggerClientEvent('gvz-anticheat:antiPed', -1)
                    CancelEvent()
                    return
                end
            end
        end
    end
end)

AddEventHandler('explosionEvent',function(source, ev)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if Config.BlackListExplosions[ev.explosionType] ~= nil then
        if Config.BlackListExplosions[ev.explosionType].block then
            CancelEvent() 
        end
        if Config.AntiExplosionLog then
            if Config.BlackListExplosions[ev.explosionType].log then
                dclog(xPlayer, 'Patlayıcı Madde Oluşturuldu! Patlayıcı Maddenin İsmi: '..Config.BlackListExplosions[ev.explosionType].name)
            end
        end
        if Config.AntiExplosionDrop then
            if Config.BlackListExplosions[ev.explosionType].drop then
                xPlayer.kick(Config.KickMessage)
            end
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.BlacklistEvents) do
        if Config.EventDetection then
            RegisterServerEvent(tostring(v))
            AddEventHandler(tostring(v), function()
                local src = source
                local xPlayer = QBCore.Functions.GetPlayer(source)

                if Config.AntiEventLog then
                    dclog(xPlayer, 'Blacklistli Event Girildi Event: '..v)
                end
                if Config.AntiEventDrop then
                    xPlayer.kick(Config.KickMessage)
                end
            end)
        end
    end
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason)
	for name in pairs(Config.BlacklistNick) do
		if(string.gsub(string.gsub(string.gsub(string.gsub(playerName:lower(), "-", ""), ",", ""), "%.", ""), " ", ""):find(Config.BlacklistNick[name])) then
			print(playerName .. " kicklendi!")
			setKickReason("İsmin Geçerli Değil İsmini Düzelt!")
			CancelEvent()
			break
		end
	end
end)

RegisterServerEvent('gvz-anticheat:dropplayer')
AddEventHandler('gvz-anticheat:dropplayer', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.kick(Config.KickMessage)
end)

RegisterServerEvent('gvz-anticheat:dclog')
AddEventHandler('gvz-anticheat:dclog', function(text)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(source)
    dclog(xPlayer, text)
end)

function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
    
    for k, v in ipairs(GetPlayerIdentifiers(xPlayer.source)) do
        if string.match(v, 'discord:') then
            identifierDiscord = v
        end
        if string.match(v, 'ip:') then
            identifierIp = v
        end
    end
	
	local discord_webhook = GetConvar('discord_webhook', Config.DiscordWebhook)
	if discord_webhook == '' then
	  return
	end
	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
        ['username'] = Config.WebhookName,
        ['avatar_url'] = Config.WebhookAvatarUrl,
        ['embeds'] = {{
          ['author'] = {
            ['name'] = 'gvz-anticheat',
            ['icon_url'] = 'https://cdn.discordapp.com/attachments/785071461516836874/802859048495349770/G3VEZE.png'
          },
          ['footer'] = {
              ['text'] = 'gvz-anticheat 1.1'
          },
          ['color'] = 12914,
          ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }}
      }
    text = '**Açıklama:** ' ..text..'\n**ID**: '..tonumber(xPlayer.source)..'\n**Steam:** '..xPlayer.identifier..'\n **Oyuncunun IC Adı:** '..xPlayer.getName()
    if identifierDiscord ~= nil then
        text = text..'\n**Discord:** <@'..string.sub(identifierDiscord, 9)..'>'
        identifierDiscord = nil
    end
    if identifierIp ~= nil then
        text = text..'\n**Ip Adresi:** '..string.sub(identifierIp, 4)
        identifierIp = nil
    end
    data['embeds'][1]['description'] = text
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end
