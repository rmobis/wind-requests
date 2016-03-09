init start
	-- local SCRIPT_VERSION = '1.1.2'

	-- DO NOT EDIT BELOW THIS LINE --
	local fishLoot = {281, 282, 3026, 3029, 3032, 9303}

	local function findwaterfishspots(exceptClose)
		for x = -7, 7 do
			for y = -5, 5 do
				if not exceptClose or (math.abs(x) > 1 or math.abs(y) > 1) then
					local curX, curY = $posx + x, $posy + y
					local item = topuseonitem(curX, curY, $posz).id

					if table.find({9582, 4037}, item) then
						return {x = curX, y = curY}
					end
				end
			end
		end

		return nil
	end
init end

auto(100)

if $lootsaround == 0 and $targetingtarget.hppc == 0 and (clientitemhotkey(3483, 'crosshairs') ~= 'not found' or $fasthotkeys) then
	local body = findwaterfishspots(true)

	while body ~= nil and tileshootable(body.x, body.y, $posz) do
		pausewalking(6^9) -- Yeah babe!

		if body ~= nil then
			local itemCount = {}

			for _, v in ipairs(fishLoot) do
				itemCount[v] = itemcount(v)
			end

			useitemon(3483, 0, ground(body.x, body.y, $posz))
			waitping()
			
			for _, v in ipairs(fishLoot) do
				local curCount = itemcount(v)

				if curCount > itemCount[v] then
					increaseamountlooted(v, curCount - itemCount[v])
				end
			end
		end

		-- If starting conditions are no longer met, abort mission!
		if $lootsaround ~= 0 or $targetingtarget.hppc ~= 0 then
			break
		end

		body = findwaterfishspots(false)
	end

	pausewalking(0) -- Orgasm.
end
