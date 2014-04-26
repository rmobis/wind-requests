-- local SCRIPT_VERSION = '1.0.0'

auto(100)

if $target.id ~= 0 and $target.id ~= $attacked.id then
	attack($target.id)
	waitping()
end