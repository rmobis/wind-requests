init start
	-- local SCRIPT_VERSION = '1.2.1'

	local function deleteSpecialAreaCall(menu)
		removespecialarea(menu.specialAreaName)
	end

	local function moveSpecialAreaName()
		if resizedSP == nil then
			return tern(draggedSP == nil, 'Move Special Area', 'Stop Moving')
		end
	end

	local function moveSpecialAreaCall(menu)
		if draggedSP == nil then
			draggedSP = menu.specialArea
		else
			draggedSP = nil
		end
	end

	local function resizeSpecialAreaName()
		if draggedSP == nil then
			return tern(resizedSP == nil, 'Resize Special Area', 'Stop Resizing')
		end
	end

	local function resizeSpecialAreaCall(menu)
		if resizedSP == nil then
			resizedSP = menu.specialArea
		else
			resizedSP = nil
		end
	end

	registermessagehandler('contextMenu_specialArea', moveSpecialAreaName, moveSpecialAreaCall)
	registermessagehandler('contextMenu_specialArea', resizeSpecialAreaName, resizeSpecialAreaCall)
	registermessagehandler('contextMenu_specialArea', 'Delete Special Area', deleteSpecialAreaCall)
	registermessagehandler('contextMenu_specialArea', MENU_SEPARATOR, nil)

	local worldWidth, worldHeight, x, y, z, width, height, avoidance, name, policy, areaType
	local specialAreaRect = {}
	local innerRect = {}

	local function gettilepos(x, y, z)
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

	local function getAreaRect(x, y, w, h)
		local ret = {x = 0, y = 0, w = 0, h = 0}

		local topLeftTilePos = gettilepos(x, y, $posz)
		local botRightTilePos = gettilepos(x + w - 1, y + h - 1, $posz)

		if topLeftTilePos and botRightTilePos then
			ret.x = math.max(topLeftTilePos.left, 0)
			ret.y = math.max(topLeftTilePos.top, 0)
			ret.w = math.min(botRightTilePos.right, worldWidth) - ret.x
			ret.h = math.min(botRightTilePos.bottom, worldHeight) - ret.y
		end

		return ret
	end

	local function drawInnerRect(areaType, x, y, width, height)
		innerRect = {w = 0, h = 0}
		if areaType == 'Square (Border Only)' then
			innerRect = getAreaRect(x + 1, y + 1, width - 2, height - 2)
		elseif areaType == 'Square (Double Border)' then
			innerRect = getAreaRect(x + 2, y + 2, width - 4, height - 4)
		end

		if innerRect.w > 0 and innerRect.h > 0 then
			setfillstyle('color', 0xFF000000)
			drawroundrect(innerRect.x, innerRect.y, innerRect.w, innerRect.h, 10, 10)
		end
	end

	useworldhud()
init end

setfontstyle('Arial', 8, 75, 0xFFFFFF, 1, 0x000000)

worldWidth, worldHeight = $worldwin.width - 2, $worldwin.height - 2

foreach settingsentry e 'Cavebot/SpecialAreas' do
	x, y, z = getsetting(e, 'Coordinates'):match('.-(%d+).-(%d+).-(%d+)')
	x, y, z = tonumber(x), tonumber(y), tonumber(z)

	if z == $posz then
		width, height = getsetting(e, 'Size'):match('(%d+).-(%d+)')
		width, height = tonumber(width), tonumber(height)

		specialAreaRect = getAreaRect(x, y, width, height)
		if specialAreaRect.w > 0 and specialAreaRect.h > 0 then
			avoidance = tonumber(getsetting(e, 'Avoidance'))
			areaType = getsetting(e, 'Type')
			name = getsetting(e, 'Name')
			policy = getsetting(e, 'Policy'):gsub('[^A-Z]', '')

			setfillstyle('color', color(255, 0, 0, math.round(100 - (avoidance / 4))))
			drawroundrect(specialAreaRect.x, specialAreaRect.y, specialAreaRect.w, specialAreaRect.h, 10, 10)
			drawInnerRect(areaType, x, y, width, height)

			if specialAreaRect.w > 10 then
				drawtext(
					string.fit(name, specialAreaRect.w - 10, '...', true),
					specialAreaRect.x + 5,
					specialAreaRect.y + 3
				)
				drawtext(
					string.fit(policy, specialAreaRect.w - 10, '...', true),
					specialAreaRect.x + 5,
					specialAreaRect.y + 15
				)
			end
		end
	end
end

if contextmenuinfo() == nil then
	if draggedSP then
		set(draggedSP, 'Coordinates', string.format('x:%i, y:%i, z:%i', $cursorinfo.x, $cursorinfo.y, $cursorinfo.z))
	elseif resizedSP then
		local x, y = get(resizedSP, 'Coordinates'):match(REGEX_COORDS)
		x, y = tonumber(x), tonumber(y)

		set(resizedSP, 'Size', string.format('%i x %i', math.max(1, 1 + ($cursorinfo.x - x)) , math.max(1, 1 + ($cursorinfo.y - y))))
	end
end