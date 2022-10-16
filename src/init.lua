--!strict
local Hooks = require(script.Hooks)

--[=[
	@class StudioPlugin
]=]

local StudioPlugin = {}

--- @prop Plugin Plugin
--- @within StudioPlugin
StudioPlugin.Plugin = require(script.Plugin)

--- @prop PluginAction PluginAction
--- @within StudioPlugin
StudioPlugin.PluginAction = require(script.PluginAction)

--- @prop Toolbar Toolbar
--- @within StudioPlugin
StudioPlugin.Toolbar = require(script.Toolbar)

--- @prop ToolbarButton ToolbarButton
--- @within StudioPlugin
StudioPlugin.ToolbarButton = require(script.ToolbarButton)

--- @prop Widget Widget
--- @within StudioPlugin
StudioPlugin.Widget = require(script.Widget)

--- @prop Menu Menu
--- @within StudioPlugin
StudioPlugin.Menu = require(script.Menu)

--- @prop MenuItem MenuItem
--- @within StudioPlugin
StudioPlugin.MenuItem = require(script.MenuItem)

--- @prop Hooks Hooks
--- @within StudioPlugin
StudioPlugin.Hooks = Hooks

--- @prop usePlugin Hooks.usePlugin
--- @within StudioPlugin
StudioPlugin.usePlugin = Hooks.usePlugin

--- @prop useToolbar Hooks.useToolbar
--- @within StudioPlugin
StudioPlugin.useToolbar = Hooks.useToolbar

--- @prop useWidget Hooks.useWidget
--- @within StudioPlugin
StudioPlugin.useWidget = Hooks.useWidget

--- @prop Context Context
--- @within StudioPlugin
StudioPlugin.Context = require(script.Context)

--- @prop tableUtil tableUtil
--- @within StudioPlugin
--- @private
StudioPlugin.tableUtil = require(script.Util.tableUtil)

--- @prop eventProps eventProps
--- @within StudioPlugin
--- @private
StudioPlugin.eventProps = require(script.Util.eventProps)

return StudioPlugin
