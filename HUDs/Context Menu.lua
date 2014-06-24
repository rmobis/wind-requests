init start
	-- local SCRIPT_VERSION = '2.2.0'

	local showProfile = true
	local showRelation = true
	local showWaypoints = true
	local mainWaypoints = {'Node', 'Stand', 'Action', 'Lure'}
	local secondaryWaypoints = {'Walk', 'Shovel', 'Rope', 'Machete', 'Ladder', 'Use'}
	local showSpecialAreas = true
	local specialAreas = {'none', 'cavebot', 'targeting', 'cavebot & targeting'}

	-- DO NOT EDIT BELOW THIS LINE --

	local defFontColor        = color(223, 223, 223)
	local defBackColor        = color(70, 70, 70)
	local defHighColor        = color(128, 128, 128)
	local boxColor            = color(70, 70, 70)
	local boxLightShadowColor = color(117, 117, 117)
	local boxDarkShadowColor  = color(41, 41, 41)

	local borderSize = 4
	local paddingSize = 3

	local PROFILE_URL = "http://www.tibia.com/community/?subtopic=characters&Submit.x=1&name="

	ALIGN_LEFT   = 0
	ALIGN_CENTER = 1
	ALIGN_RIGHT  = 2

	MENU_SEPARATOR = '-- SEPARATOR --'

	local items, highlight, contextMenu, maxWidth, maxHeight, clicked

	do -- Register default handlers
		if showProfile then
			local function showProfileName(m)
				return 'Show page for ' .. m.creature.name
			end

			local function showProfileCall(m)
				openbrowser(PROFILE_URL .. m.creature.name:gsub(' ', '+'))
			end

			registermessagehandler('contextMenu_player', showProfileName, showProfileCall)
			registermessagehandler('contextMenu_player', MENU_SEPARATOR, nil)
		end

		if showRelation then
			local function currentRelationName(m)
				if m.creature.id ~= $self.id then
					return m.creature.name .. ': ' .. m.creature.teamname, m.creature.teamcolor, nil, color(70, 70, 70)
				end
			end

			registermessagehandler('contextMenu_player', currentRelationName, nil)
			registermessagehandler('contextMenu_player', MENU_SEPARATOR, nil)

			-- enemy
			local function setEnemyName(m)
				if m.creature.id ~= $self.id and not m.creature.isenemy then
					return 'Set ' .. m.creature.name .. ' as enemy'
				end
			end

			local function setEnemyCall(m)
				setrelation(m.creature, 'enemy')
			end

			registermessagehandler('contextMenu_player', setEnemyName, setEnemyCall)

			-- ally
			local function setAllyName(m)
				if m.creature.id ~= $self.id and (not m.creature.isally or m.creature.isleader) then
					return 'Set ' .. m.creature.name .. ' as ally'
				end
			end

			local function setAllyCall(m)
				setrelation(m.creature, 'ally')
			end

			registermessagehandler('contextMenu_player', setAllyName, setAllyCall)

			-- leader
			local function setLeaderName(m)
				if m.creature.id ~= $self.id and not m.creature.isleader then
					return 'Set ' .. m.creature.name .. ' as leader'
				end
			end

			local function setLeaderCall(m)
				setrelation(m.creature, 'leader')
			end

			registermessagehandler('contextMenu_player', setLeaderName, setLeaderCall)
			registermessagehandler('contextMenu_player', MENU_SEPARATOR, nil)
		end

		if showWaypoints then
			for _, v in ipairs({mainWaypoints, secondaryWaypoints}) do
				for _, vv in ipairs(v) do
					-- I learned this trick with JavaScript; basically, we call a anonymous
					-- function that returns the function we'll actually use. The trick is
					-- that we pass to this first anonymous function the type of the node
					-- we want the returned function to add. This works because the inner
					-- function is created in a scope where `type` has the desired value,
					-- so it's value is retained for future calls.
					registermessagehandler('contextMenu_world', 'Add ' .. vv, (function(type)
						return function(m)
							addwaypoint(type, m.posx, m.posy, m.posz)
						end
					end)(vv))
				end

				registermessagehandler('contextMenu_world', MENU_SEPARATOR, nil)
			end
		end

		if showSpecialAreas then
			for _, v in ipairs(specialAreas) do
				registermessagehandler('contextMenu_world', 'Add Special Area (' .. v:capitalizeall() .. ')', (function(type)
					return function(m)
						addspecialarea(type, m.posx, m.posy, m.posz)
					end
				end)(v))
			end

			registermessagehandler('contextMenu_world', MENU_SEPARATOR, nil)
		end
	end

	local function loadCategories(...)
		local categories = {...}

		for _, v in ipairs(categories) do
			local cat = 'contextMenu_' .. v
			foreach messagehandler m cat do
				local text, fontColor, backColor, highColor, align

				if type(m.name) == 'function' then
					text, fontColor, highColor, backColor, align = m.name(contextMenu)
				else
					text = m.name
				end

				if text and text ~= '' then
					local width
					if text == MENU_SEPARATOR then
						maxHeight = maxHeight + 8
					else
						width = (measurestring(text))

						maxHeight = maxHeight + 19
						maxWidth = math.max(maxWidth, width)
					end

					table.insert(items, {
						text      = text,
						width     = width,
						callback  = m.callback,
						fontColor = fontColor or defFontColor,
						highColor = highColor or defHighColor,
						backColor = backColor or defBackColor
					});
				end
			end
		end
	end

	filterinput(false, true, true, false)
	function inputevents(e)
		local eventItem, itemIndex
		for i, v in ipairs(items) do
			if v.id == e.elementid then
				eventItem = v
				itemIndex = i
				break
			end
		end


		highlight = itemIndex
		if e.type == IEVENT_LMOUSEUP then
			if eventItem and eventItem.callback then
				eventItem.callback(contextMenu)
			end

			clicked = true
			highlight = nil
			waitforevents(false)
			press('[ESC]')
			waitforevents(true)
		end
	end

	setfontstyle('Tahoma', 7, 75, defFontColor, 1, 0x000000)
	setantialiasing(true)
init end

auto(10)

contextMenu = contextmenuinfo()

-- This prevents the HUD from redrawing after clicking
if clicked then
	clicked = contextMenu ~= nil
	contextMenu = nil
end

if contextMenu == nil then
	highlight = nil
	return
end

items = {}
maxWidth, maxHeight = 0, -4
local fullWidth, fullHeight
do -- Bootstrap

	-- Load categories
	if contextMenu.type == 'battle' or contextMenu.itemid == 99 then
		contextMenu.creature = getcreaturebyid(contextMenu.creatureid)

		if contextMenu.creature.isplayer then
			loadCategories(contextMenu.type .. 'Player', 'player')
		elseif contextMenu.creature.isnpc then
			loadCategories(contextMenu.type .. 'NPC', 'NPC')
		elseif contextMenu.creature.ismonster then
			loadCategories(contextMenu.type .. 'Monster', 'monster')
		end

		loadCategories(contextMenu.type .. 'Creature', 'creature')
	end

	if contextMenu.type == 'world' then
		if not contextMenu.creature then
			loadCategories('worldItem', 'item')
		end

		if contextMenu.posz == $posz then

			do
				local i = 0
				foreach settingsentry e 'Cavebot/Waypoints' do
					local x, y, z = get(e, 'Coordinates'):match(REGEX_COORDS)
					x, y, z = tonumber(x), tonumber(y), tonumber(z)

					if z == $posz then
						local diffX, diffY = contextMenu.posx - x, contextMenu.posy - y

						if diffX >= 0 and diffY >= 0 then
							local w, h = get(e, 'Range'):match(REGEX_RANGE)
							w, h = tonumber(w), tonumber(h)

							if diffX < w and diffY < h then
								contextMenu.waypoint = e
								contextMenu.waypointID = i
							end
						end
					end

					i = i + 1
				end

				if contextMenu.waypoint then
					loadCategories('worldWaypoint', 'waypoint')
				end
			end

			do
				foreach settingsentry e 'Cavebot/SpecialAreas' do
					local x, y, z = get(e, 'Coordinates'):match(REGEX_COORDS)
					x, y, z = tonumber(x), tonumber(y), tonumber(z)

					if z == $posz then
						local diffX, diffY = contextMenu.posx - x, contextMenu.posy - y

						if diffX >= 0 and diffY >= 0 then
							local w, h = get(e, 'Size'):match(REGEX_RANGE)
							w, h = tonumber(w), tonumber(h)

							if diffX < w and diffY < h then
								contextMenu.specialArea = e
								contextMenu.specialAreaName = get(e, 'Name')
							end
						end
					end
				end

				if contextMenu.specialArea then
					loadCategories('worldSpecialArea', 'specialArea')
				end
			end
		end
	elseif contextMenu.type == 'container' then
		loadCategories('containerItem', 'item')
	elseif contextMenu.type == 'equip' then
		loadCategories('equipItem', 'item')
	end
	loadCategories(contextMenu.type)

	-- We set it as true from the beginning so that it also removes the first
	-- item if it's a separator; we obviously don't want the first item to be a
	-- separator. NOTE: relies on the fact that ipairs() will traverse the
	-- table in ascending order, which isn't guaranteed by the reference manual
	-- but is the common implementation
	local lastSep = true

	-- Instead of removing the items at the for loop, we simply set it to nil
	-- and normalize it after; this is because if we did remove it, it would
	-- shift the indexes and end up fucking up posterior checks
	for i, v in ipairs(items) do
		local curSep = v.text == MENU_SEPARATOR
		if curSep and (lastSep or i == #items) then
			items[i] = nil
			maxHeight = maxHeight - 8
		end

		lastSep = curSep
	end
	table.normalize(items)

	-- No item to display, abort mission!
	if #items == 0 then
		return
	end

	-- The Tibia context menu has an extra width of 44 pixels for the longest
	-- item; here we account for that
	maxWidth = maxWidth + 44

	fullWidth, fullHeight = maxWidth + 2*borderSize, maxHeight + 2*borderSize
	setposition($clientwin.x + contextMenu.x - fullWidth - 2,$clientwin.y + contextMenu.y)
end

do -- Draw Container
	-- Draw main box
	setfillstyle('color', boxColor)
	setbordercolor(-1)
	drawrect(0, 0, fullWidth, fullHeight)

	-- Draw shadows
	setbordercolor(boxLightShadowColor)
	drawline(0, 0, fullWidth, 0)
	drawline(0, 0, 0, fullHeight)
	drawline(2, fullHeight - 2, fullWidth - borderSize, 0)
	drawline(fullWidth - 2, 2, 0, fullHeight - borderSize)

	setbordercolor(boxDarkShadowColor)
	drawline(2, 2, fullWidth - borderSize, 0)
	drawline(2, 2, 0, fullHeight - borderSize)
	drawline(0, fullHeight, fullWidth, 0)
	drawline(fullWidth, 0, 0, fullHeight)
end

do -- Draw items
	local curHeight = borderSize
	for i, v in ipairs(items) do
		-- Separators get special treatment here
		if v.text == MENU_SEPARATOR then
			setbordercolor(boxDarkShadowColor)
			drawline(borderSize, curHeight, maxWidth, 0)

			setbordercolor(boxLightShadowColor)
			drawline(borderSize, curHeight + 1, maxWidth, 0)

			curHeight = curHeight + 8
		else

			-- This is a dirty, dirrty attempt of making the code shorter; and
			-- that's what I love the most about programming
			local alignOffset = ((maxWidth - paddingSize - v.width) / 2) * (v.align or ALIGN_LEFT)

			-- Set style
			setbordercolor(-1)
			setfontcolor(v.fontColor)
			setfillstyle('color', tern(i == highlight, v.highColor, v.backColor))

			-- Draw stuff
			v.id = drawrect(borderSize, curHeight, maxWidth, 15)
			drawtext(v.text, borderSize + paddingSize + alignOffset, curHeight + paddingSize)

			curHeight = curHeight + 19
		end
	end
end