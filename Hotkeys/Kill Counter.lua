init start
	-- local SCRIPT_VERSION = '1.1.1'

	-- If set to true, will save kill count to $chardb so that it is persisted
	-- throughout different sessions.
	local saveToDB = true

	-- DO NOT EDIT BELOW THIS LINE --

	-- We don't want to override the object because that'd delete all data in
	-- killCount.creatures
	if killCount == nil then
		killCount = {
			creatures = {},
			lastRan = $timems
		}

		killCount.set = function(count, ...)
			local names = table.each({...}, string.lower)

			for _, v in ipairs(names) do
				killCount.creatures[v] = count

				if killCount.saveToDB then
					$chardb:setvalue('killCount', v, count)
				end
			end
		end

		killCount.add = function(addAmount, ...)
			local names = table.each({...}, string.lower)

			for _, v in ipairs(names) do
				killCount.set(killCount.get(v) + addAmount, v)
			end
		end

		killCount.reset = function(...)
			killCount.set(0, ...)
		end

		killCount.get = function(...)
			local names = table.each({...}, string.lower)

			local count = 0
			for _, v in ipairs(names) do
				local cCount = killCount.creatures[v]

				if cCount == nil then
					cCount = 0
					killCount.set(cCount, v)
				end

				count = count + cCount
			end

			return count
		end

		if saveToDB then
			-- Thanks to @Lucas Terra for implementing database iterators for the
			-- sole purpose of making this script better. Lucas, you rock!
			foreach $chardb:sectionvalue v 'killCount' do
				killCount.set(v.value, v.name)
			end
		end
	end

	-- We only set saveToDB now because else it would cause unnecessary updates
	-- queried to the database when we first read it.
	killCount.saveToDB = saveToDB
init end

auto(100)
foreach newmessage m do
	if m.type == MSG_INFO then
		local creature = m.content:match(REGEX_LOOT)

		if creature then
			killCount.add(1, creature)
		end
	end
end

-- You're welcome, Leonardo
killCount.lastRan = $timems