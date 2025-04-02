local util = {}

---makes copy of given object, does not handle recursion
---it also copies the metatable
---http://lua-users.org/wiki/CopyTable
---@param orig any
---@return any
function util.deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[util.deepcopy(orig_key)] = util.deepcopy(orig_value)
		end
		setmetatable(copy, util.deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

return util
