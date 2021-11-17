local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

export type PluginProps = {
  plugin: Plugin,
}

return function(props: PluginProps?)
  local props = if type(props) == "table" then props else {}

  return Roact.createElement(Context.Plugin.Provider, {
    value = props.plugin,
  }, props[Roact.Children])
end
