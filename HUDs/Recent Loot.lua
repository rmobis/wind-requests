init start
	-- local SCRIPT_VERSION = '1.1.0'

	local warnItems = {'cheese', 'life ring'} -- You can add more items here
	local maxLines = 10 -- Max lines to display at once

	-- DO NOT EDIT BELOW THIS LINE --

	local lootMsgs = {}
	local regColor = 0x00FF00
	local warnColor = 0xFF0000
init end

setfontstyle('Tahoma', 7, 75, regColor, 1, 0x000000)

foreach newmessage m do
	local _, loot = m.content:match(REGEX_LOOT)
	if loot then
		local message, color = m.content, regColor

		for k, v in ipairs(warnItems) do
			if loot:find(v, 1, false) then
				color = warnColor
				break
			end
		end

		table.insert(lootMsgs, 1, {message = message, color = color})
	end
end

while #lootMsgs > maxLines do
	table.remove(lootMsgs)
end

for k, msg in ipairs(lootMsgs) do
	setfontcolor(msg.color)

	drawtext(msg.message, 0, k * 10)
end

setposition($worldwin.left + 3, $worldwin.bottom - #lootMsgs * 10 - 13)