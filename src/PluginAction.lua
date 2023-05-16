--!strict
--[=[
  @class PluginAction

  ```lua
  Roact.createElement(PluginAction, {
    id = "MyAction",
    name = "My Action",
    icon = "rbxassetid://123456789",

    [Roact.Event.Triggered] = function(rbx: PluginAction)
      print("Triggered!")
    end,
  })
  ```
]=]
local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local tableUtil = require(script.Parent.Util.tableUtil)
local eventProps = require(script.Parent.Util.eventProps)
local makeIcon = require(script.Parent.Util.makeIcon)

local Component = Roact.Component:extend("PluginAction")

--[=[
  @interface PluginActionProps
  @within PluginAction
  .id string -- The unique identifier for this action
  .name string? -- The name/title of this action
  .tooltip string? -- The tooltip to display when hovering over this action
  .icon (string | number)? -- The icon to display for this action
  .enabled boolean? -- Whether or not this action is enabled
  .bindable boolean? -- Whether or not this action can be bound to a keyboard shortcut

  Default values:
  ```lua
  {
    name = "",
    tooltip = "",
    icon = "",
    enabled = true,
    bindable = true,
  }
  ```
]=]
export type PluginActionProps = {
	id: string,
	name: string?,
	tooltip: string?,
	icon: (string | number)?,
	enabled: boolean?,
	bindable: boolean?,
}

Component.defaultProps = {
	name = "",
	tooltip = "",
	icon = "",
	enabled = true,
	bindable = true,
}

function Component:init()
	local action = self.props.plugin:CreatePluginAction(
		self.props.id,
		self.props.name,
		self.props.tooltip,
		makeIcon(self.props.icon),
		self.props.bindable
	)

	self.events = {}

	for eventName, callback in eventProps.pick(self.props) do
		if callback ~= eventProps.NONE then
			self.events[eventName] = action[eventName]:Connect(function(...)
				callback(action, ...)
			end)
		end
	end

	self.action = action
end

function Component:didUpdate(oldProps: PluginActionProps)
	for eventName, callback in eventProps.changed(oldProps, self.props) do
		if self.events[eventName] ~= nil then
			self.events[eventName]:Disconnect()
		end

		if callback ~= eventProps.NONE then
			self.events[eventName] = self.action[eventName]:Connect(function(...)
				callback(self.action, ...)
			end)
		end
	end
end

function Component:willUnmount()
	table.clear(self.events)
	self.action:Destroy()
end

function Component:render()
	return nil
end

return function(props: PluginActionProps?)
	return Context.useContext(Context.Plugin, function(plugin: Plugin)
		return Roact.createElement(
			Component,
			tableUtil.merge(props, {
				plugin = plugin,
			})
		)
	end)
end
