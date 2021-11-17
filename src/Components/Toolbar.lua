local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local MergeUtil = require(script.Parent.Parent.Util.MergeUtil)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginToolbar")

export type PluginToolbarProps = {
  name: string,
}

function Component:init()
  self.toolbar = (self.props.plugin :: Plugin):CreateToolbar(self.props.name)
end

function Component:willUnmount()
  self.toolbar:Destroy()
end

function Component:render()
  return e(Context.Toolbar.Provider, {
    value = self.toolbar,
  }, self.props[Roact.Children])
end

return function(props: PluginToolbarProps?)
  return Context.use(Context.Plugin)(function(plugin)
    return e(
      Component,
      MergeUtil.Merge(props, {
        plugin = plugin,
      })
    )
  end)
end
