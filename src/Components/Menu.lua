local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local MergeUtil = require(script.Parent.Parent.Util.MergeUtil)

local e = Roact.createElement

local Component = Roact.Component:extend("Menu")

export type MenuProps = {
  id: string,
  open: boolean?,
  onOpen: ((PluginMenu) -> nil)?,
  onClose: ((PluginMenu, PluginAction) -> nil)?,
}

function Component:init()
  local menu = (self.props.plugin :: Plugin):CreatePluginMenu(self.props.id)

  function self.open()
    self.isOpen = true

    task.spawn(function()
      local result = menu:ShowAsync()

      self.isOpen = false

      if type(self.props.onClose) == "function" then
        self.props.onClose(menu, result)

        if self.props.open then
          self.open()
        end
      end
    end)

    if type(self.props.onOpen) == "function" then
      self.props.onOpen(menu)
    end
  end

  self.menu = menu
end

function Component:didMount()
  if self.props.open then
    self.open()
  end
end

function Component:didUpdate(prevProps: MenuProps)
  if self.props.open ~= prevProps.open and self.props.open == true then
    self.open()
  end
end

function Component:willUnmount()
  self.menu:Destroy()
end

function Component:render()
  if not (self.props.open or self.isOpen) then
    return nil
  end

  return e(Context.Menu.Provider, {
    value = {
      Instance = self.menu,
      open = self.open,
    },
  }, self.props[Roact.Children])
end

return function(props: MenuProps?)
  return Context.use(Context.Plugin)(function(plugin)
    return e(
      Component,
      MergeUtil.Merge(props, {
        plugin = plugin,
      })
    )
  end)
end
