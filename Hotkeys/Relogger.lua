-- This script has been discontinued, may be malfunctioning and will not be
-- updated. Please try @Leonardo's solution: http://goo.gl/nbs4TA

init start
	-- local SCRIPT_VERSION = '1.1.0'

	-- The bot will open these backpacks, in this order. The first item is the
	-- name of the backpack, the second the location and the third is whether
	-- it should be open as new, which defaults to true.
	local backpacks = {
		{'Backpack of Holding', 'back'},
		{'Dragon Backpack'    , '0'   },
		{'Expedition Backpack', '1'   , false},
		{'Brocade Backpack'   , '1'   },
		{'Brown Bag'          , '0'   },
	}

	local serverSaveWait = {15, 20} -- Wait time on server save, in minutes

	local nextTry = $timems
init end

auto(100)

if not $connected and $timems >= nextTry then
	set('Cavebot/Enabled', 'no')
	set('Targeting/Enabled', 'no')
	set('Looting/Enabled', 'no')

	reconnect()
	while not $connected do
		wait(90, 110)
	end
	waitping()

	local bp, loc, new, count, parentCont
	for _, v in ipairs(backpacks) do
		bp, loc, new = table.unpack(v)
		new = tern(new ~= nil, new, true)
		count = #getopencontainers()

		openitem(bp, loc, new)
		if new then
			while #getopencontainers() ~= count + 1 do
				wait(90, 110)
			end
		else
			waitping()
		end

		resizewindows(0)
	end

	set('Cavebot/Enabled', 'yes')
	set('Targeting/Enabled', 'yes')
	set('Looting/Enabled', 'yes')
end

foreach newmessage m do
	if m.type == MSG_RED then
		local min = m.content:match(REGEX_SERVER_SAVE)

		if min then
			nextTry = $timems + (tonumber(min) + math.random(table.unpack(serverSaveWait))) * 60000
			break
		end
	end
end
