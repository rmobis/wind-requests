init start
	-- local SCRIPT_VERSION = '1.0.0'

	-- The message to be said. If you write ':attacker:' it will be replaced
	-- with the current attacker's name. It's recommended that you keep this
	-- string short and in all lower case, if you're not having Wind Addon's
	-- fast hotkeys enabled.
	local message = "pk :attacker: at coryms"

	-- The name of your guild, so that the bot knows which channel to send the
	-- message to. THIS HAS TO BE ALREADY OPENED OR OTHERWISE THE SCRIPT WON'T
	-- WORK AT ALL.
	local guildChat = "Guild Name"

	-- The interval between messages, in ms; this is to prevent repeatedly
	-- spamming the same message and getting you muted.
	local interval = 30000

	-- DO NOT EDIT BELOW THIS LINE --

	local lastMessage = 0
init end

auto(100)

if $pattacker.id ~= 0 and $timems - lastMessage > interval then
	local realMessage = message:gsub(":attacker:", $pattacker.name:lower())

	say(guildChat, realMessage)

	if waitmessage($name, realMessage, 2000, false, guildChat) then
		lastMessage = $timems
	end
end