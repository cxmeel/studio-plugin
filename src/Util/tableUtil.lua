--!strict
--[=[
	@class tableUtil
	@private

	An internal utility module for working with tables.
]=]

--[=[
	@function merge
	@within tableUtil

	@param ... any -- The tables to merge
	@return table

	Merges the given tables into a single table. Later tables
	will overwrite earlier tables. If a parameter is not a table,
	it will be ignored.
]=]
local function merge<T>(...: any): T
	local result = {}

	for dictionaryIndex = 1, select("#", ...) do
		local dictionary = select(dictionaryIndex, ...)

		if type(dictionary) ~= "table" then
			continue
		end

		for key, value in pairs(dictionary) do
			result[key] = value
		end
	end

	return result
end

return {
	merge = merge,
}
