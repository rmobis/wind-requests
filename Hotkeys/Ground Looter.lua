init start
	-- local SCRIPT_VERSION = '1.0.0'

	local capMin = 5
	local lootCat = 'ds'
	local lootRange = 4

	-- DO NOT EDIT BELOW THIS LINE --
init end

auto(100, 200)
if $cap > capMin and maround() == 0 and $lootbodies == 0 then
	local maxRatio, minDist, bestItem, items = 0, math.huge, nil, {}

	foreach lootingitem l lootCat do
		-- Add it to list only if we have enough capacity to loot it and still
		-- remain above minimum capacity
		if $cap > capMin + l.weight then
			table.insertsorted(items, {id = l.id, dest = l.destination, ratio = l.sellprice / l.weight}, 'ratio', 'desc')
		end
	end

	-- Find best item/location to collect
	for y = -lootRange, lootRange do
		for x = -lootRange, lootRange do
			if tilereachable($posx + x, $posy + y, $posz) then
				local tile = gettile($posx + x, $posy + y, $posz)

				-- We do it the other way around so that we can know the actual
				-- index of the item in the browsefield, if we need it
				local j = 0
				for i = tile.itemcount, 1, -1 do
					-- Creatures and not moveable items do not appear on the browsefield, so we ignore them
					if tile.item[i].id ~= 99 and not itemproperty(tile.item[i].id, ITEM_NOTMOVEABLE) then
						j = j + 1
						for _, v in ipairs(items) do
							if tile.item[i].id == v.id then
								local curDist = math.max(0, math.abs(x) - 1) + math.max(0, math.abs(y) - 1)
								if v.ratio > maxRatio or (v.ratio == maxRatio and curDist < minDist) then
									maxRatio = v.ratio
									minDist  = curDist
									bestItem = {
										id    = v.id,
										dest  = v.dest,
										index = j,
										x     = $posx + x,
										y     = $posy + y
									}
								end
							end
						end
					end
				end
			end
		end
	end

	local browseField = getcontainer('Browse Field')
	if browseField then
		for i = 1, browseField.itemcount do
			for _, v in ipairs(items) do
				if v.id == browseField.item[i].id and v.ratio >= maxRatio then
					maxRatio = v.ratio
					minDist  = 0
					bestItem = {
						id    = v.id,
						dest  = v.dest,

						-- This means the browse field is already open
						index = -1
					}
				end
			end
		end
	end

	if bestItem ~= nil then
		set('Cavebot/Enabled', 'no')

		-- Only reach if we have to
		if minDist ~= 0 then
			reachlocation(bestItem.x, bestItem.y, $posz)
			waitping()
		end

		-- No need to use browse field if we're getting the top item
		if bestItem.index == 1 then
			moveitems(bestItem.id, bestItem.dest, ground(bestItem.x, bestItem.y, $posz))
			waitping()
		elseif bestItem.index > 1 then
			contextmenu('Browse Field', 0, ground(bestItem.x, bestItem.y, $posz))
			waitping()

			local browseField = getcontainer(windowcount() - 1)

			-- Go to last page, because that's where top items are
			if browseField.curpage ~= browseField.lastpage then
				changepage(browseField.lastpage, browseField.index)
				waitping()

				-- If the number of items on the last page is lower than the
				-- index of our best item, it's actually on the previous page.
				if browseField.itemcount < bestItem.index then
					previouspage(browseField.index)
					waitping()
				end
			end

			moveitems(bestItem.id, bestItem.dest, 'Browse Field')
			waitping()
		end

		set('Cavebot/Enabled', 'yes')
	end
end