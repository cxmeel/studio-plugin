--!strict
--[=[
  @class Widget

  ```lua
  Roact.createElement(Widget, {
    id = "MyWidget",
    title = "My Widget",
    enabled = true,
    minSize = Vector2.new(100, 178),

    [Roact.Event.WindowFocused] = function(rbx: DockWidgetPluginGui)
      print("Window focused!")
    end,

    -- This is a custom event which is fired immediately after the
    -- widget is created
    [Roact.Event.OnInit] = function(rbx: DockWidgetPluginGui)
      print("Window initialized!")
    end,

    -- This is a custom event which is fired when the widget's
    -- enabled property is changed
    [Roact.Event.OnToggle] = function(rbx: DockWidgetPluginGui)
      print("Window is", rbx.Enabled and "open" or "closed")
    end,
  })
  ```
]=]
local Context = require(script.Parent.Context)
local Roact = require(script.Parent.Parent.Roact)

local eventProps = require(script.Parent.Util.eventProps)
local tableUtil = require(script.Parent.Util.tableUtil)

local Component = Roact.Component:extend("PluginWidget")

--[=[
  @interface WidgetProps
  @within Widget
  .id string -- The unique identifier for this widget
  .initState Enum.InitialDockState? -- The initial dock state of this widget
  .zindex Enum.ZIndexBehavior? -- The z-index behavior of this widget
  .enabled boolean? -- Whether or not this widget is enabled (visible)
  .overrideRestore boolean? -- Whether or not to override the default restore behavior
  .floatSize Vector2? -- The size of this widget when floating
  .minSize Vector2? -- The minimum size of this widget
  .title string? -- The title of this widget

  Default values:
  ```lua
  {
    initState = Enum.InitialDockState.Float,
    zindex = Enum.ZIndexBehavior.Sibling,
    enabled = false,
    overrideRestore = false,
    floatSize = Vector2.new(300, 300),
    minSize = Vector2.zero,
  }
  ```
]=]
export type WidgetProps = {
	id: string,
	initState: Enum.InitialDockState?,
	zindex: Enum.ZIndexBehavior?,
	enabled: boolean?,
	overrideRestore: boolean?,
	floatSize: Vector2?,
	minSize: Vector2?,
	title: string?,
}

Component.defaultProps = {
	initState = Enum.InitialDockState.Float,
	zindex = Enum.ZIndexBehavior.Sibling,
	enabled = false,
	overrideRestore = false,
	floatSize = Vector2.new(300, 300),
	minSize = Vector2.zero,
}

local CUSTOM_EVENTS = {
	["OnInit"] = true,
	["OnToggle"] = true,
}

function Component:init()
	local widgetInfo = DockWidgetPluginGuiInfo.new(
		self.props.initState,
		self.props.enabled,
		self.props.overrideRestore,
		self.props.floatSize.X,
		self.props.floatSize.Y,
		self.props.minSize.X,
		self.props.minSize.Y
	)

	local widget = self.props.plugin:CreateDockWidgetPluginGui(self.props.id, widgetInfo)

	widget.Name = self.props.id
	widget.Title = self.props.title or self.props.id
	widget.ResetOnSpawn = false
	widget.ZIndexBehavior = self.props.zindex

	widget:GetPropertyChangedSignal("Enabled"):Connect(function()
		if self.props[Roact.Event.OnToggle] ~= nil then
			self.props[Roact.Event.OnToggle](widget)
		end
	end)

	self.events = {}

	for eventName, callback in eventProps.pick(self.props) do
		if CUSTOM_EVENTS[eventName] then
			continue
		end

		if callback ~= eventProps.NONE then
			self.events[eventName] = widget[eventName]:Connect(function(...)
				callback(widget, ...)
			end)
		end
	end

	self.widget = widget
end

function Component:didMount()
	if self.props[Roact.Event.OnInit] ~= nil then
		self.props[Roact.Event.OnInit](self.widget)
	end
end

function Component:didUpdate(oldProps: WidgetProps)
	local newProps = self.props

	if oldProps.enabled ~= newProps.enabled then
		self.widget.Enabled = newProps.enabled
	end

	if oldProps.title ~= newProps.title then
		self.widget.Title = newProps.title
	end

	if oldProps.zindex ~= newProps.zindex then
		self.widget.ZIndexBehavior = newProps.zindex
	end

	for eventName, callback in eventProps.changed(oldProps, newProps) do
		if CUSTOM_EVENTS[eventName] then
			continue
		end

		if self.events[eventName] ~= nil then
			self.events[eventName]:Disconnect()
		end

		if callback ~= eventProps.NONE then
			self.events[eventName] = self.widget[eventName]:Connect(function(...)
				callback(self.widget, ...)
			end)
		end
	end
end

function Component:willUnmount()
	table.clear(self.events)
	self.widget:Destroy()
end

function Component:render()
	return Roact.createElement(Context.Widget.Provider, {
		value = self.widget,
	}, {
		widget = Roact.createElement(Roact.Portal, {
			target = self.widget,
		}, self.props[Roact.Children]),
	})
end

return function(props: WidgetProps)
	return Context.useContext(Context.Plugin, function(plugin: Plugin)
		return Roact.createElement(
			Component,
			tableUtil.merge({
				plugin = plugin,
			}, props)
		)
	end)
end
