local Context = require(script.Parent.Context)

local function createHook(hooks, context, transform)
  local values = hooks.useContext(context)

  return if type(transform) == "function"
    then transform(values)
    else values
end

return {
  usePlugin = function(hooks): Plugin
    return createHook(hooks, Context.Plugin)
  end,
  useToolbar = function(hooks): PluginToolbar
    return createHook(hooks, Context.Toolbar)
  end,
  useWidget = function(hooks): DockWidgetPluginGui
    return createHook(hooks, Context.Widget)
  end,
}
