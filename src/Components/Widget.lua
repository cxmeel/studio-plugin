local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local MergeUtil = require(script.Parent.Parent.Util.MergeUtil)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginWidget")

export type PluginWidgetProps = {
  id: string,
  initState: Enum.InitialDockState?,
  zindex: Enum.ZIndexBehavior?,
  enabled: boolean?,
  overrideRestore: boolean?,
  floatSize: Vector2?,
  minSize: Vector2?,
  title: string?,
  onInit: ((boolean) -> nil)?,
  onToggle: ((boolean) -> nil)?,
}

Component.defaultProps = {
  initState = Enum.InitialDockState.Float,
  zindex = Enum.ZIndexBehavior.Sibling,
  enabled = false,
  overrideRestore = false,
  floatSize = Vector2.new(300, 300),
  minSize = Vector2.new(),
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

  local widget = self.props.plugin:CreateDockWidgetPluginGui(
    self.props.id,
    widgetInfo
  )

  widget.Name = self.props.title .. " <" .. self.props.id .. ">"
  widget.Title = self.props.title or self.props.id
  widget.ResetOnSpawn = false
  widget.ZIndexBehavior = self.props.zindex

  widget:GetPropertyChangedSignal("Enabled"):Connect(function()
    if type(self.props.onToggle) == "function" then
      self.props.onToggle(widget.Enabled)
    end
  end)

  self.widget = widget
end

function Component:didUpdate(prevProps: PluginWidgetProps)
  if prevProps.enabled ~= self.props.enabled then
    self.widget.Enabled = self.props.enabled
  end

  if prevProps.title ~= self.props.title then
    self.widget.Title = self.props.title or self.props.id
    self.widget.Name = self.props.title .. " <" .. self.props.id .. ">"
  end

  if prevProps.zindex ~= self.props.zindex then
    self.widget.ZIndexBehavior = self.props.zindex
  end
end

function Component:didMount()
  if type(self.props.onInit) == "function" then
    self.props.onInit(self.widget.Enabled)
  end
end

function Component:willUnmount()
  self.widget:Destroy()
end

function Component:render()
  return e(Context.Widget.Provider, {
    value = self.widget,
  }, {
    widget = e(Roact.Portal, {
      target = self.widget,
    }, self.props[Roact.Children]),
  })
end

return function(props: PluginWidgetProps?)
  return Context.use(Context.Plugin)(function(plugin)
    return e(
      Component,
      MergeUtil.Merge(props, {
        plugin = plugin,
      })
    )
  end)
end
