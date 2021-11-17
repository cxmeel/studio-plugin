local Roact = require(script.Parent.Parent.Roact)

local plugin = script:FindFirstAncestorOfClass("Plugin")

local ctx = Roact.createContext

local function use(context)
  return function(render)
    return Roact.createElement(context.Consumer, {
      render = function(value)
        return render(value)
      end,
    })
  end
end

return {
  Plugin = ctx(plugin),
  Toolbar = ctx(nil),
  ToolbarButton = ctx({}),
  Widget = ctx(nil),
  Menu = ctx(nil),

  use = use,
}
