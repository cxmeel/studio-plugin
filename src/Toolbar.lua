--!strict
--[=[
  @class Toolbar

  ```lua
  Roact.createElement(Toolbar, {
    name = "My Toolbar",
  }, {
    Button1 = Roact.createElement(Toolbar.Button, {
      id = "Button1",
      name = "Button 1",
    }),
  })
  ```
]=]
local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local tableUtil = require(script.Parent.Util.tableUtil)

local Component = Roact.Component:extend("PluginToolbar")

--[=[
  @interface ToolbarProps
  @within Toolbar
  .name string -- The name of the toolbar
]=]
export type ToolbarProps = {
	name: string,
}

function Component:init()
	self.toolbar = self.props.plugin:CreateToolbar(self.props.name)
end

function Component:willUnmount()
	self.toolbar:Destroy()
end

function Component:render()
	return Roact.createElement(Context.Toolbar.Provider, {
		value = self.toolbar,
	}, self.props[Roact.Children])
end

return function(props: ToolbarProps)
	return Context.useContext(Context.Plugin, function(plugin: Plugin)
		return Roact.createElement(
			Component,
			tableUtil.merge(props, {
				plugin = plugin,
			})
		)
	end)
end
