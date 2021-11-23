local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local MergeUtil = require(script.Parent.Parent.Util.MergeUtil)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("MenuAction")

export type MenuActionProps = {
  id: string,
  label: string?,
  icon: (number | string)?,
  separator: boolean?,
  metadata: any?,
  onActivated: (() -> nil)?,
}

function Component:init()
  function self.activate()
    if type(self.props.onActivated) == "function" then
      self.props.onActivated(self.props.menu, self.action, self.props.metadata)
    end
  end

  self:_createAction()
end

function Component:_createAction()
  local menu = self.props.menu :: PluginMenu
  local action = self.action

  if action then
    action:Destroy()
  end

  if self.props.separator then
    action = menu:AddSeparator()
  else
    action = menu:AddNewAction(
      self.props.id,
      self.props.label,
      if type(self.props.icon) == "number"
        then table.concat({"rbxassetid://", tostring(self.props.icon)}, "")
        else self.props.icon
    )

    action.Triggered:Connect(self.activate)
  end

  self.action = action
end

function Component:didUpdate(prevProps: MenuActionProps)
  if prevProps.separator ~= self.props.separator then
    self:_createAction()
  end

  if not self.props.separator then
    if prevProps.label ~= self.props.label then
      self:_createAction()
    end

    if prevProps.icon ~= self.props.icon then
      self:_createAction()
    end
  end
end

function Component:willUnmount()
  if self.action then
    self.action:Destroy()
  end
end

function Component:render()
  return nil
end

return function(props: MenuActionProps?)
  return Context.use(Context.Menu)(function(menu)
    return e(
      Component,
      MergeUtil.Merge(props, {
        menu = menu.Instance,
      })
    )
  end)
end
