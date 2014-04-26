init start
	-- local SCRIPT_VERSION = '1.0.1'

	local alerts = {
		{
			name  = 'Player on Screen',
			sound = 'playeronscreen.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			safelist  = {'Bubble', 'Cachero'}
		},
		{
			name  = 'Player Attacking',
			sound = 'playerattacking.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			safelist  = {'Bubble', 'Cachero'}
		},
		{
			name  = 'Monster Attacking',
			sound = 'monsterattacking.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			safelist  = {'Rat', 'Bat'}
		},
		{
			name  = 'Private Message',
			sound = 'privatemessage.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			safelist  = {'Bubble', 'Cachero'}
		},
		{
			name  = 'Default Message',
			sound = 'defaultmessage.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			safelist  = {'Bubble', 'Cachero'}
		},
		{
			name  = 'GM Detected',
			sound = 'gmdetected.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false
		},
		{
			name  = 'Disconnected',
			sound = 'disconnected.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false
		},
		{
			name  = 'Character Stuck',
			sound = 'characterstuck.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			stuckTime = 30000 -- ms
		},
		{
			name  = 'Health Below',
			sound = 'lowhealth.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			pcBelow   = 50
		},
		{
			name  = 'Mana Below',
			sound = 'lowmana.wav',

			playSound = false,
			pauseBot  = false,
			logout    = false,
			pcBelow   = 50
		}
	}

	-- Do not edit below this line

	do
		local tests = {
			function(safelist)  return paroundignore(10, table.unpack(safelist)) > 0 end,
			function(safelist)  return $pattacker.id ~= 0 and not table.find(safelist, $pattacker.name:lower()) end,
			function(safelist)  return $mattacker.id ~= 0 and not table.find(safelist, $mattacker.name:lower()) end,
			function(safelist)  foreach newmessage m do if m.type == MSG_PVT then return true end end return false end,
			function(safelist)  foreach newmessage m do if m.type == MSG_WHISPER or m.type == MSG_DEFAULT or m.type == MSG_YELL then return true end end return false end,
			function()          foreach creature c do if c.name:starts('GM') or c.name:starts('CM') then return true end end return false end,
			function()          return not $connected end,
			function(stuckTime) return $standtime > stuckTime end,
			function(pcBelow)   return $hppc < pcBelow end,
			function(pcBelow)   return $mppc < pcBelow end
		}

		for i = 1, #alerts do
			local alert = alerts[i]
			alert.test = tests[i]

			if alert.safelist then
				table.lower(alert.safelist)
			end
		end
	end
init end

auto(100)
listas('Alerts')
for _, v in ipairs(alerts) do
	if v.test(v.safelist or v.stuckTime or v.pcBelow) then
		if v.playSound then
			playsound(v.sound)
		end
		if v.pauseBot then
			pausebot(true)
		end
		if v.logout then
			xlog()
		end
	end
end