local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local MergeUtil = require(script.Parent.Parent.Util.MergeUtil)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginAction")

export type PluginActionProps = {
  id: string,
  tooltip: string?,
  icon: (string | number)?,
  label: string?,
  enabled: boolean?,
  bindable: boolean?,
  onActivated: (() -> nil)?,
}

Component.defaultProps = {
  tooltip = "",
  icon = "",
  label = "",
  enabled = true,
  bindable = true,
}

function Component:init()
  local action = (self.props.plugin :: Plugin):CreatePluginAction(
    self.props.id,
    self.props.label,
    self.props.tooltip,
    if type(self.props.icon) == "number"
      then "rbxassetid://" .. tostring(self.props.icon)
      else self.props.icon,
    self.props.bindable
  )

  action.Triggered:Connect(function()
    if not self.props.enabled then
      return
    end

    if
      type(self.props.toolbarButton) == "table"
      and type(self.props.toolbarButton.onActivated) == "function"
    then
      self.props.toolbarButton.onActivated("PluginAction")
      return
    end

    if type(self.props.onActivated) == "function" then
      self.props.onActivated()
    end
  end)

  self.action = action
end

function Component:willUnmount()
  self.action:Destroy()
end

function Component:render()
  return nil
end

return function(props: PluginActionProps?)
  return Context.use(Context.Plugin)(function(plugin)
    return Context.use(Context.ToolbarButton)(function(toolbarButton)
      return e(
        Component,
        MergeUtil.merge(props, {
          plugin = plugin,
          toolbarButton = toolbarButton,
        })
      )
    end)
  end)
end
