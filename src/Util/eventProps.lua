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
		if type(prop) == "table" and tostring(prop):match("^RoactHostEvent%(.*%)$") and prop.name ~= nil then
			events[prop.name] = value
		end
	end

	return events
end

--[=[
	@function changed
	@within eventProps

	@param oldProps table -- The old properties
	@param newProps table -- The new properties
	@return { [string]: (...any) -> void | userdata }

	Extracts event props that have changed from the given props
	tables. This is useful for determining which events need to
	be connected/disconnected.
]=]
local function ChangedEvents(oldProps, newProps)
	local events = {}

	local oldEvents = PickEvents(oldProps)
	local newEvents = PickEvents(newProps)

	for eventName, callback in newEvents do
		if oldEvents[eventName] ~= callback then
			events[eventName] = callback or NONE
		end
	end

	for eventName, _ in oldEvents do
		if newEvents[eventName] == nil then
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
