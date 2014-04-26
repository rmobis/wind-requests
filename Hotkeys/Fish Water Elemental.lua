init start
	-- local SCRIPT_VERSION = '1.1.1'

	-- If set to true, will pause walking and wait for fresh bodies to become
	-- 'fisable'.
	local waitFresh = false


	-- DO NOT EDIT BELOW THIS LINE --

	local fishLoot = {281, 282, 3026, 3029, 3032, 9303}

	-- I wish I could have made this a more generic function, but it would most
	-- likely make it less efficient for the current use case; I know... I will
	-- pay for that in the future. Meh... whatever, bring it on!
	local function findwaterfishspots(exceptClose)
		local hasFresh = false

		for x = -7, 7 do
			for y = -5, 5 do
				-- This lets us ignore bodies that are too close and might fuck
				-- up because of character's first movements, but still account
				-- for them after it's already standing.
				if not exceptClose or (math.abs(x) > 1 or math.abs(y) > 1) then
					local curX, curY = $posx + x, $posy + y
					local item = topuseonitem(curX, curY, $posz).id

					if item == 9582 then
						return {x = curX, y = curY}
					elseif item == 4037 then
						hasFresh = true
					end
				end
			end
		end

		return nil, hasFresh
	end
init end

auto(100)

if $lootsaround == 0 and $targetingtarget.hppc == 0 then
	local old, fresh = findwaterfishspots(true)

	while old ~= nil or (waitFresh and fresh) do
		pausewalking(6^9) -- Yeah babe!

		if old ~= nil then
			local itemCount = {}

			for _, v in ipairs(fishLoot) do
				itemCount[v] = itemcount(v)
			end

			useitemon(3483, 0, ground(old.x, old.y, $posz))
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

		old, fresh = findwaterfishspots(false)
	end

	pausewalking(0) -- Orgasm.
end