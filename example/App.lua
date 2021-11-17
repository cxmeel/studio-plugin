local Roact = require(script.Parent.Packages.Roact)
local StudioPlugin = require(script.Parent.Packages.StudioPlugin)

local e = Roact.createElement

local App = Roact.Component:extend("App")

function App:init()
  self:setState({
    menu = false,
    widget = false,
  })
end

function App:render()
  return e(StudioPlugin.Plugin, {
    plugin = self.props.plugin,
  }, {
    toolbar = e(StudioPlugin.Toolbar, {
      name = "StudioPlugin",
    }, {
      button = e(StudioPlugin.ToolbarButton, {
        id = "main-button",
        label = "Test",
        active = self.state.menu,
        onActivated = function()
          self:setState({ menu = true })
        end,
      }),
    }),

    widget = e(StudioPlugin.Widget, {
      id = "test-widget",
      title = "Test Widget",
      enabled = self.state.widget,
      onInit = function(enabled)
        self:setState({ widget = enabled })
      end,
      onToggle = function(enabled)
        self:setState({ widget = enabled })
      end,
    }),

    menu = e(StudioPlugin.Menu, {
      id = "test-menu",
      open = self.state.menu,
      onClose = function()
        self:setState({ menu = false })
      end,
    }, {
      e(StudioPlugin.MenuAction, {
        id = "widget-toggle",
        label = (self.state.widget and "Close" or "Open") .. " Widget",
        onActivated = function()
          self:setState({ widget = not self.state.widget })
        end,
      }),

      e(StudioPlugin.MenuAction, {
        separator = true,
      }),

      e(StudioPlugin.MenuAction, {
        id = "close-menu",
        label = "Close Menu",
        icon = "rbxasset://textures/StudioSharedUI/clear.png",
      }),
    }),
  })
end

return App
