local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local MergeUtil = require(script.Parent.Parent.Util.MergeUtil)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginToolbarButton")

export type PluginToolbarButtonProps = {
  id: string,
  tooltip: string?,
  icon: (string | number)?,
  label: string?,
  alwaysAvailable: boolean?,
  enabled: boolean?,
  active: boolean?,
  onActivated: (() -> nil)?,
}

Component.defaultProps = {
  tooltip = "",
  icon = "",
  alwaysAvailable = true,
  enabled = true,
  active = false,
}

function Component:init()
  local button = (self.props.toolbar :: PluginToolbar):CreateButton(
    self.props.id,
    self.props.tooltip,
    if type(self.props.icon) == "number"
      then table.concat({"rbxassetid://", tostring(self.props.icon)}, "")
      else self.props.icon,
    self.props.label
  )

  button.ClickableWhenViewportHidden = self.props.alwaysAvailable
  button.Enabled = self.props.enabled
  button:SetActive(self.props.active)

  button.Click:Connect(function()
    if type(self.props.onActivated) == "function" then
      self.props.onActivated("ToolbarButton")
    end
  end)

  self.button = button
end

function Component:didUpdate(prevProps: PluginToolbarButtonProps)
  if prevProps.active ~= self.props.active then
    self.button:SetActive(self.props.active)
  end

  if prevProps.enabled ~= self.props.enabled then
    self.button.Enabled = self.props.enabled
  end

  if prevProps.alwaysAvailable ~= self.props.alwaysAvailable then
    self.button.ClickableWhenViewportHidden = self.props.alwaysAvailable
  end
end

function Component:willUnmount()
  self.button:Destroy()
end

function Component:render()
  return e(Context.ToolbarButton.Provider, {
    value = {
      Instance = self.button,
      onActivated = self.props.onActivated,
    },
  }, self.props[Roact.Children])
end

return function(props: PluginToolbarButtonProps?)
  return Context.use(Context.Toolbar)(function(toolbar)
    return e(
      Component,
      MergeUtil.Merge(props, {
        toolbar = toolbar,
      })
    )
  end)
end
