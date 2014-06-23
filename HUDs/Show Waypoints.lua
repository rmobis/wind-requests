init start
	-- local SCRIPT_VERSION = '1.2.1'

	local waypointColors = {
		walk    = 0xAAF200,
		node    = 0x2A0736,
		stand   = 0x00AACC,
		shovel  = 0xEB8540,
		rope    = 0xFFCC00,
		machete = 0x003366,
		ladder  = 0xC55186,
		use     = 0x36693E,
		action  = 0x00FFFF,
		lure    = 0xCCCCCC
	}

	local function deleteWaypointCall(menu)
		removewaypoint(menu.waypointID)
	end

	local function moveWaypointName()
		if resizedWpt == nil then
			return tern(draggedWpt == nil, 'Move Waypoint', 'Stop Moving')
		end
	end

	local function moveWaypointCall(menu)
		if draggedWpt == nil then
			draggedWpt = menu.waypoint
		else
			draggedWpt = nil
		end
	end

	local function resizeWaypointName()
		if draggedWpt == nil then
			return tern(resizedWpt == nil, 'Resize Waypoint', 'Stop Resizing')
		end
	end

	local function resizeWaypointCall(menu)
		if resizedWpt == nil then
			resizedWpt = menu.waypoint
		else
			resizedWpt = nil
		end
	end

	registermessagehandler('contextMenu_waypoint', moveWaypointName, moveWaypointCall)
	registermessagehandler('contextMenu_waypoint', resizeWaypointName, resizeWaypointCall)
	registermessagehandler('contextMenu_waypoint', 'Delete Waypoint', deleteWaypointCall)
	registermessagehandler('contextMenu_waypoint', MENU_SEPARATOR, nil)

	local xOffset, yOffset, worldWidth, worldHeight, x, y, z, topLeftTilePos,
	      botRightTilePos, width, height, text, label
	local waypointRect = {}

	function gettilepos(x, y, z)
		local tile = getobjectarea(x, y, z)

		if tile == nil then
			local xDiff, yDiff = x - $posx, y - $posy
			if math.abs($posx - x) <= 7 then
				tile = getobjectarea(x, $posy, $posz)
				xDiff = 0
			elseif math.abs($posy - y) <= 5 then
				tile = getobjectarea($posx, y, $posz)
				yDiff = 0
			else
				tile = getobjectarea($posx, $posy, $posz)
			end

			-- Some strange stuff happens when you go from 0 to -1, so I'm
			-- adding this as a precaution.
			if tile ~= nil then
				local width, height = $worldwin.width, $worldwin.height

				tile.left    = tile.left    + (width * xDiff)
				tile.right   = tile.right   + (width * xDiff)
				tile.centerx = tile.centerx + (width * xDiff)
				tile.top     = tile.top     + (height * yDiff)
				tile.bottom  = tile.bottom  + (height * yDiff)
				tile.centery = tile.centery + (height * yDiff)
			end
		end

		return tile
	end

	useworldhud()
init end

setfontstyle('Tahoma', 7, 75, 0xFFFFFF, 1, 0x000000)

xOffset, yOffset = $worldwin.left - $clientwin.left, $worldwin.top - $clientwin.top
worldWidth, worldHeight = $worldwin.right - $worldwin.left - 2, $worldwin.bottom - $worldwin.top - 2

local i = 0
foreach settingsentry e 'Cavebot/Waypoints' do
	x, y, z = getsetting(e, 'Coordinates'):match(REGEX_SPA_COORDS)
	x, y, z = tonumber(x), tonumber(y), tonumber(z)

	if z == $posz then
		width, height = getsetting(e, 'Range'):match(REGEX_SPA_SIZE)
		width, height = tonumber(width), tonumber(height)

		topLeftTilePos = gettilepos(x, y, z)
		botRightTilePos = gettilepos(x + width - 1, y + height - 1, z)

		if topLeftTilePos and botRightTilePos then
			waypointRect.left   = math.max(topLeftTilePos.left  , 0)
			waypointRect.top    = math.max(topLeftTilePos.top   , 0)
			waypointRect.right  = math.min(botRightTilePos.right , worldWidth)
			waypointRect.bottom = math.min(botRightTilePos.bottom, worldHeight)
			waypointRect.width  = waypointRect.right - waypointRect.left
			waypointRect.height = waypointRect.bottom - waypointRect.top

			if waypointRect.width > 0 and waypointRect.height > 0 then
				label = getsetting(e, 'Label')
				text = tern(#label == 0, tostring(i), label .. ' (' .. i .. ')')
				wptType = getsetting(e, 'Type')

				setfillstyle('color', (waypointColors[wptType:lower()] or 0) + (math.floor(2.55*50)*16777216))
				drawroundrect(
					waypointRect.left,
					waypointRect.top,
					waypointRect.width,
					waypointRect.height,
					10, 10
				)

				if waypointRect.width > 10 then
					drawtext(
						string.fit(text, waypointRect.width - 10, '...', true),
						waypointRect.left + 5,
						waypointRect.top + 3
					)
					drawtext(
						string.fit(wptType, waypointRect.width - 10, '...', true),
						waypointRect.left + 5,
						waypointRect.top + 15
					)
				end
			end
		end
	end

	i = i + 1
end

if contextmenuinfo() == nil then
	if draggedWpt then
		set(draggedWpt, 'Coordinates', string.format('x:%i, y:%i, z:%i', $cursorinfo.x, $cursorinfo.y, $cursorinfo.z))
	elseif resizedWpt then
		local x, y = get(resizedWpt, 'Coordinates'):match(REGEX_COORDS)
		x, y = tonumber(x), tonumber(y)

		set(resizedWpt, 'Range', string.format('%i x %i', math.max(1, 1 + ($cursorinfo.x - x)) , math.max(1, 1 + ($cursorinfo.y - y))))
	end
end