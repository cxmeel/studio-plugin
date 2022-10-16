--!strict
--[=[
	@class Context

	Provides context to the Roact app. This enables the app
	to access the current plugin/widget/toolbar/etc. from
	anywhere below the root component.
]=]
local Roact = require(script.Parent.Parent.Roact)

local plugin = script:FindFirstAncestorOfClass("Plugin")

local ctx = Roact.createContext

type RoactContext = typeof(ctx(nil))

--[=[
	@function useContext
	@within Context

	@param context Roact.Context
	@param render (value: T) -> Roact.Element
	@return Roact.Element

	A function that returns a component that will render the
	given render function with the value of the context. This
	is useful for consuming contexts in a component, where
	you cannot use hooks.
]=]
local function useContext<T>(context: RoactContext, render: (value: T) -> Roact.Element)
	return Roact.createElement(context.Consumer, {
		render = function(value)
			return render(value)
		end,
	})
end

--[=[
	@prop Plugin Roact.Context<Plugin>
	@within Context

	The plugin context. This is the [plugin][Plugin] that the app is
	running in. This is automatically detected, providing
	that this module is installed within the plugin itself.

	If you have installed this module outside of the plugin,
	you can use the Plugin component to provide the plugin
	instance.
]=]
local PluginContext = ctx(plugin)

--[=[
	@prop Toolbar Roact.Context<PluginToolbar>
	@within Context

	The toolbar context. This is the [toolbar][PluginToolbar] that the
	buttons are added to.
]=]
local ToolbarContext = ctx(nil)

--[=[
	@prop Widget Roact.Context<DockWidgetPluginGui>
	@within Context

	The widget context. This is the [widget][DockWidgetPluginGui] that
	the app is rendered inside of.
]=]
local WidgetContext = ctx(nil)

--[=[
	@prop Menu Roact.Context<PluginMenu>
	@within Context

	The menu context. This is the [menu][PluginMenu] that
	[menu items][PluginMenu] are added to.
]=]
local MenuContext = ctx(nil)

return {
	Plugin = PluginContext,
	Toolbar = ToolbarContext,
	Widget = WidgetContext,
	Menu = MenuContext,

	useContext = useContext,
}
