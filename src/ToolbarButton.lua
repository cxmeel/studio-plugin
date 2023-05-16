--!strict
--[=[
  @class ToolbarButton

  ```lua
  Roact.createElement(ToolbarButton, {
    id = "Button1",
    name = "Button 1",
    active = true,

    [Roact.Event.Click] = function(rbx: PluginToolbarButton)
      print("Clicked!")
    end,
  })
  ```
]=]
local Context = require(script.Parent.Context)
local Roact = require(script.Parent.Parent.Roact)

local eventProps = require(script.Parent.Util.eventProps)
local makeIcon = require(script.Parent.Util.makeIcon)
local tableUtil = require(script.Parent.Util.tableUtil)

local Component = Roact.Component:extend("PluginToolbarButton")

--[=[
  @interface ToolbarButtonProps
  @within ToolbarButton
  .id string -- The id of the button
  .name string? -- The name/label of the button
  .tooltip string? -- The tooltip to display when hovering over the button
  .icon (string | number)? -- The icon to display for the button
  .enabled boolean? -- Whether or not the button is enabled
  .active boolean? -- Whether or not the button displays as active (pressed down)
  .alwaysAvailable boolean? -- Whether or not the button is always available, even when the viewport is not visible

  Default values:
  ```lua
  {
    name = "",
    tooltip = "",
    icon = "",
    enabled = true,
    active = false,
    alwaysAvailable = true,
  }
  ```
]=]
export type ToolbarButtonProps = {
	id: string,
	name: string?,
	tooltip: string?,
	icon: (string | number)?,
	enabled: boolean?,
	active: boolean?,
	alwaysAvailable: boolean?,
}

Component.defaultProps = {
	name = "",
	tooltip = "",
	icon = "",
	enabled = true,
	active = false,
	alwaysAvailable = true,
}

function Component:init()
	local button =
		self.props.toolbar:CreateButton(self.props.id, self.props.tooltip, makeIcon(self.props.icon), self.props.label)

	button.ClickableWhenViewportHidden = self.props.alwaysAvailable
	button.Enabled = self.props.enabled
	button:SetActive(self.props.active)

	self.events = {}

	for eventName, callback in eventProps.pick(self.props) do
		if callback ~= eventProps.NONE then
			self.events[eventName] = button[eventName]:Connect(function(...)
				callback(button, ...)
			end)
		end
	end

	self.button = button
end

function Component:didUpdate(oldProps: ToolbarButtonProps)
	local newProps = self.props

	if oldProps.active ~= newProps.active then
		self.button:SetActive(newProps.active)
	end

	if oldProps.enabled ~= newProps.enabled then
		self.button.Enabled = newProps.enabled
	end

	if oldProps.alwaysAvailable ~= newProps.alwaysAvailable then
		self.button.ClickableWhenViewportHidden = newProps.alwaysAvailable
	end

	if oldProps.icon ~= newProps.icon then
		self.button.Icon = makeIcon(newProps.icon)
	end

	for eventName, callback in eventProps.changed(oldProps, newProps) do
		if self.events[eventName] ~= nil then
			self.events[eventName]:Disconnect()
		end
		
		if callback ~= eventProps.NONE then
			self.events[eventName] = self.button[eventName]:Connect(function(...)
				callback(self.button, ...)
			end)
		end
	end
end

function Component:willUnmount()
	table.clear(self.events)
	self.button:Destroy()
end

function Component:render()
	return nil
end

return function(props: ToolbarButtonProps?)
	return Context.useContext(Context.Toolbar, function(toolbar: PluginToolbar)
		return Roact.createElement(
			Component,
			tableUtil.merge(props, {
				toolbar = toolbar,
			})
		)
	end)
end
