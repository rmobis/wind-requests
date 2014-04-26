init start
	-- local SCRIPT_VERSION = '1.0.1'

	local invisCreatures = {'Stalker'}
	local stuckTime = 0 -- Set to 0 to always attack
	local spellToUse = 'exori'

	-- DO NOT EDIT BELOW THIS LINE --
	table.lower(invisCreatures)
	local spellToUseInfo, spellType = spellinfo(spellToUse), 'spell'
	if spellToUseInfo.castarea == 'None' then
		spellToUseInfo, spellType = runeinfo(spellToUse), 'rune'
	end
init end

auto(100)

if $standtime >= stuckTime then
	foreach newmessage m do
		if m.type == MSG_STATUSLOG then
			local _, _, name = m.content:match(REGEX_DMG_TAKEN)
			if name and table.find(invisCreatures, name:lower()) and maround(7, name:lower()) == 0 then
				if spellType == 'spell' and cancastspell(spellToUseInfo) then
					cast(spellToUseInfo.words)
					waitping()
				elseif spellType == 'rune' then
					useoncreature(spellToUseInfo.itemid, $self)
					waitping()
				end
			end
		end
	end
end