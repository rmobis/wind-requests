init start
	-- local SCRIPT_VERSION = '1.0.0'

	local header, closeButton, closed, moving
	local cursorPosition = {}
	local engines = {'Cavebot', 'Looting', 'Targeting', 'Spell Healer', 'Potion Healer', 'Condition Healer', 'Mana Trainer'}

	filterinput(false, true, false, false)

	function inputevents(e)
		if e.type == IEVENT_LMOUSEUP then
			if e.elementid == closeButton then
				closed = true
				return
			end

			for _, v in ipairs(engines) do
				if e.elementid == v.shape then
					toggle(v.name:gsub(' ', '') .. '/Enabled')
					return
				end
			end
		elseif e.elementid == header then
			if e.type == IEVENT_MMOUSEDOWN then
				moving = true
				cursorPosition.x = $cursor.x
				cursorPosition.y = $cursor.y
				return
			elseif e.type == IEVENT_MMOUSEUP then
				moving = false
				return
			end
		end
	end

	-- Taken from Sirmate's MMH
	local blueGradient  = {0.0, color(36, 68, 105, 20), 0.23, color(39, 73, 114, 20), 0.76, color(21, 39, 60, 20)}
	local blackGradient = {0.0, color(75, 75, 75, 20), 0.23, color(45, 45, 45, 20), 0.76, color(19, 19, 19, 20)}
	local redGradient   = {0.0, color(136, 35, 12, 20), 0.23, color(139, 37, 13, 20), 0.76, color(92, 6, 6, 20)}
	local greenGradient = {0.0, color(65, 96, 12, 20), 0.23, color(67, 99, 13, 20), 0.76, color(36, 52, 6, 20)}

	for k, v in ipairs(engines) do
		engines[k] = {
			name  = v,
			shape = nil
		}
	end

	setposition($clientwin.right - 424, $worldwin.top + 300)
	setfontstyle('Tahoma', 8, 75, 0xFFFFFF, 1, 0x000000)
	setfillstyle('gradient', 'linear', 2, 0, 0, 0, 21)
	setbordercolor(color(0, 0, 0, 50))
	setantialiasing(true)
init end

auto(100)
if moving then
	auto(10)
	local curPosition = getposition()
	setposition(
		curPosition.x + ($cursor.x - cursorPosition.x),
		curPosition.y + ($cursor.y - cursorPosition.y)
	)
	cursorPosition.x = $cursor.x
	cursorPosition.y = $cursor.y
end
if closed then
	return
end



addgradcolors(table.unpack(blueGradient))
header = addshape('roundrect', 0, 0, 150, 20, 3, 3)
addtext('ENGINE STATES', 24, 3)

addgradcolors(table.unpack(blackGradient))
closeButton = addshape('roundrect', 130, 0, 20, 20, 3, 3)
addtext('X', 137, 3)

local isEnabled
for k, v in ipairs(engines) do
	addgradcolors(table.unpack(blackGradient))
	addshape('roundrect', 0, k * 23, 150, 20, 3, 3)
	addtext(v.name, 6, k * 23 + 3)

	isEnabled = get(v.name:gsub(' ', '') .. '/Enabled') == 'yes'
	addgradcolors(table.unpack(tern(isEnabled, greenGradient, redGradient)))
	engines[k].shape = addshape('roundrect', 120, k * 23, 30, 20, 3, 3)
	addtext(tern(isEnabled, 'ON', 'OFF'), 126 + tern(isEnabled, 2, 0),  k * 23 + 3)
end