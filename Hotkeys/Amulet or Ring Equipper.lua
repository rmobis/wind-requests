init start
	-- local SCRIPT_VERSION = '1.0.0'

	local item = 'life ring' -- Can be a ring or an amulet

	-- DO NOT EDIT BELOW THIS LINE
	item = itemid(item)
	local slot, slotName = $neck, 'neck'
	if itemname(item):lower():find('ring') then
		slot, slotName = $finger, 'finger'
	end
init end

auto(100, 200)
if slot.id ~= item and itemcount(item) > 0 then
	equipitem(item, slotName)
	waitping()
end