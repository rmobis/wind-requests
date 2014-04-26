init start
	-- local SCRIPT_VERSION = '0.3.0'

	-- Where to get the items from; to loot from ground, open the tile's browse
	-- field on last page and write 'Browse Field'
	local getFrom = 'Beach Backpack'

	-- If set to true, will look on all pages, starting from the last one.
	local allPages = true

	-- If set to true, will open the next backpack on the destinations if it
	-- gets full
	local openNext = true

	-- Specify where each item goes
	local config = {
		{
			items = {'strong health potion', 'strong mana potion', 'soul orb', 'essence of a bad dream', 'poisonous slime'}, -- Items by name
			dest  = '1' -- Container by index
		},
		{
			items = {'stealth ring', 'dark shield', 'wailing widow\'s necklace'}, -- Items by ID
			dest  = '2' -- Container by name
		},
		{
			items = {'*'}, -- Use '*' to refer to any item; ignores containers
			dest  = '3' -- Ground by position
		}
	}

	-- DO NOT EDIT BELOW THIS LINE --
	local allItems = {}
	for _, v in ipairs(config) do
		if table.find(v.items, '*') then
			v.items = '*'
		else
			table.map(v.items, itemid)
			allItems = table.merge(allItems, v.items)
		end
	end
init end

auto(100)
local cont = getcontainer(getFrom)
-- I'm not really into using while loops to iterate over collections, but this
-- seemed to be the only way to do so and still be able to force it to try the
-- same index again; thanks to @Colandus for the heads up
local i = 0
while i < #config do
	i = i + 1

	local entry = config[i]

	-- For the special case of all items, we'll handle it separately, more like
	-- 'all items but the ones listed before and containers'. To do so, we
	-- actually loop through the items in the container and check that
	-- condition.
	if entry.items == '*' then
		local j = 0
		-- Same as above for while loops to iterate over collections
		while j < cont.itemcount do
			j = j + 1

			local item = cont.item[j]
			local itemData = iteminfo(item.id)

			if not itemData.iscontainer and not table.find(allItems, item.id) then
				moveitems(item.id, entry.dest, getFrom)
				waitping()

				-- Since we messed with the containers items, we don't actually
				-- know what's inside it, starting from the last index we
				-- checked, so we force it to check again
				j = j - 1
			end
		end
	else
		for _, item in ipairs(entry.items) do
			if itemcount(item, getFrom) > 0 then
				moveitems(item, entry.dest, getFrom)
				waitping()
			end
		end
	end

	-- If it's a container and not a ground location
	if openNext and not entry.dest:match('$ground') then
		local entryCont = getcontainer(entry.dest)
		if entryCont.emptycount == 0 then
			-- Going backwards should save us a few comparisions, since the new
			-- container should be most likely at the end of the current one
			for k = entryCont.itemcount, 1, -1 do
				local item = entryCont.item[i]
				local itemData = iteminfo(item.id)

				if not table.find(entry.items, item.id) and itemData.iscontainer then
					openitem(item.id, entryCont.index, false, k)
					waitping()

					-- Because our destination container got full, some
					-- moveitems events might not have been correctly ran, so
					-- we try again with the same entry
					i = i - 1
				end
			end
		end
	end
end

if allPages then
	if cont.ispage and cont.curpage ~= 1 then
		previouspage(cont.index)
	elseif cont.hashigher then
		higherwindows(cont.index, true)
	end
	waitping()
end