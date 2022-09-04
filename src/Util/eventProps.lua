--!strict
--[=[
	@class eventProps
	@private

	An internal utility module for extracting event props from
	component props.
]=]

--[=[
	@prop NONE userdata
	@within eventProps

	An empty userdata value that can be used to represent a
	non-existent event prop.
]=]
local NONE = newproxy(true)

--[=[
	@function pick
	@within eventProps

	@param props table
	@return { [string]: (...any) -> void }

	Extracts event props from the given props table.
]=]
local function PickEvents(props)
	local events = {}

	if type(props) ~= "table" then
		return events
	end

	for prop, value in props do
		if type(prop) == "table" and tostring(prop):match("RoactHostEvent(.*)") and prop.name ~= nil then
			events[prop.name] = value
		end
	end

	return events
end

--[=[
	@function changed
	@within eventProps

	@param prev table -- The previous props
	@param next table -- The new props
	@return { [string]: (...any) -> void | userdata }

	Extracts event props that have changed from the given props
	tables. This is useful for determining which events need to
	be connected/disconnected.
]=]
local function ChangedEvents(prev, next)
	local events = {}

	for eventName, callback in PickEvents(next) do
		if prev[eventName] ~= callback then
			events[eventName] = callback or NONE
		end
	end

	for eventName, _ in PickEvents(prev) do
		if next[eventName] == nil then
			events[eventName] = NONE
		end
	end

	return events
end

return {
	NONE = NONE,

	pick = PickEvents,
	changed = ChangedEvents,
}
