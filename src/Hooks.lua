--!strict
--[=[
	@class Hooks

	Provides a set of hooks for use with Roact. This will require
	`@kampfkarren/roact-hooks` to also be installed.
]=]
local Context = require(script.Parent.Context)

local function createHook(hooks, context, transform)
	local values = hooks.useContext(context)

	return if type(transform) == "function" then transform(values) else values
end

--[=[
	@function usePlugin
	@within Hooks

	@param hooks RoactHooks
	@return Plugin

	Provides access to the plugin instance.
]=]
local function usePlugin(hooks)
	return createHook(hooks, Context.Plugin)
end

--[=[
	@function useToolbar
	@within Hooks

	@param hooks RoactHooks
	@return PluginToolbar

	Provides access to the plugin toolbar.
]=]
local function useToolbar(hooks)
	return createHook(hooks, Context.Toolbar)
end

--[=[
	@function useWidget
	@within Hooks

	@param hooks RoactHooks
	@return DockWidgetPluginGui

	Provides access to the plugin widget.
]=]
local function useWidget(hooks)
	return createHook(hooks, Context.Widget)
end

return {
	usePlugin = usePlugin,
	useToolbar = useToolbar,
	useWidget = useWidget,
}
