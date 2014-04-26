init start
	-- local SCRIPT_VERSION = '1.0.1'

	local filename = 'Loot - ' .. $name .. '.txt'
	local hideEmpty = false

	-- DO NOT EDIT BELOW THIS LINE --
init end

auto(1000)

local handler = nil
foreach newmessage m do
	if m.type == MSG_INFO and not (hideEmpty and m.content:find('nothing')) then
		if handler == nil then
			handler = io.open(filename, 'a+')
		end

		handler:write(os.date('%H:%M') .. ' ' .. m.content .. '\n')
	end
end

if handler ~= nil then
	handler:close()
end