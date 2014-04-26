init start
	-- local SCRIPT_VERSION = '1.0.1'

	local hasteSpell = 'utani hur'

	-- DO NOT EDIT BELOW THIS LINE --
	hasteSpell = spellinfo(hasteSpell)
init end

auto(100)
if $hastetime < $pingaverage * 2 + 500 and cancastspell(hasteSpell) then
	cast(hasteSpell.words)
	waitping()
end