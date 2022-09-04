--!strict
--[=[
  @class Plugin

  You shouldn't need to use this component. The context provider will
  automatically detect the plugin, providing that this module is installed
  within the plugin itself.

  If you have installed this module outside of the plugin, you can use
  this component to provide the plugin instance. You may also need to
  use this component if you are using a plugin such as hotswap.

  ```lua
  Roact.createElement(Plugin, {
    plugin = plugin,
  })
  ```
]=]
local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

--[=[
  @interface PluginProps
  @within Plugin
  .plugin Plugin -- The plugin instance to use
]=]
export type PluginProps = {
	plugin: Plugin,
}

return function(props: PluginProps?)
	props = props or {}

	if props.plugin then
		assert(
			typeof(props.plugin) == "Instance" and props.plugin.ClassName == "Plugin",
			"plugin must be a Plugin instance"
		)
	end

	return Roact.createElement(Context.Plugin.Provider, {
		value = props.plugin,
	}, props[Roact.Children])
end
