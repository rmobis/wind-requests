-- local SCRIPT_VERSION = '1.1.0'

local minStamina  = 16 * 60 -- In minutes
local accountList = {
	{
		account   = 'account1',
		password  = 'password1',
		character = 'character1'
	},
	{
		account   = 'account2',
		password  = 'password2',
		character = 'character2'
	},
	{
		account   = 'account3',
		password  = 'password3',
		character = 'character3'
	}
}

-- DO NOT EDIT BELOW THIS LINE --
for _, v in ipairs(accountList) do
	v.character = v.character:lower()
end

if $stamina < minStamina then
	local curAccount  = table.find(accountList, $name:lower(), 'character')
	local nextAccount = accountList[(curAccount % #accountList) + 1]

	waitandlogout()
	waitping()
	keyevent(VK_ESCAPE)
	waitping()
	connect(nextAccount.account, nextAccount.password, nextAccount.character)
end