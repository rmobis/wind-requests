init start
	-- local SCRIPT_VERSION = '1.1.0'

	-- Minimum amount of flasks to drop
	local minAmount = 30

	-- Minimum cap to start dropping flasks
	local minCap = 50

	-- DO NOT EDIT BELOW THIS LINE --
	local randMinAmount = minAmount
init end

auto(1000, 3000)

if $cap <= minCap and flasks() >= randMinAmount then
	if maround() ~= 0 then
		wait(500, 1000)
	else
		pausewalking(10000)

		for i = 283, 285 do
			if itemcount(i) > 0 then
				moveitems(i, 'ground')
				waitping()
			end
		end

		pausewalking(0)
	end

	randMinAmount = minAmount + math.random(-5, 5)
end