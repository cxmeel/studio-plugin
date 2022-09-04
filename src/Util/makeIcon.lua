--!strict
local function makeIcon(icon: string | number): string
	return type(icon) == "number" and "rbxassetid://" .. tostring(icon) or icon
end

return makeIcon
