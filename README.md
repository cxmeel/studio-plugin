# StudioPlugin

Helpful little Roact components to scaffold and build out your plugins using purely Roact.

> **Warning**
>
> If you are upgrading from `v1.0.1` to `v1.1.0` or higher, please read the [changelog.md][changelog] for breaking changes.

```lua
local StudioPlugin = require(path.to.StudioPlugin)
local Roact = require(path.to.Roact)

local e = Roact.createElement

function Component:render()
  return e(StudioPlugin.Plugin, {
    plugin = plugin,
  }, {
    toolbar = e(StudioPlugin.Toolbar, {
      name = "My Toolbar",
    }, {
      button1 = e(StudioPlugin.Toolbar.Button, {
        name = "Button 1",
        icon = "rbxassetid://123456789",
        tooltip = "Button 1 tooltip",

        [Roact.Event.Click] = function()
          self:setState({
            widgetVisible = not self.state.widgetVisible,
          })
        end,
      }),
    }),

    widget = e(StudioPlugin.Widget, {
      id = "MyWidget",
      title = "My Widget",
      enabled = self.state.widgetVisible,

      [Roact.Event.OnInit] = function(rbx: DockWidgetPluginGui)
        self:setState({
          widgetVisible = rbx.Enabled,
        })
      end,

      [Roact.Event.OnToggle] = function(rbx: DockWidgetPluginGui)
        self:setState({
          widgetVisible = rbx.Enabled,
        }),
      end,
    }, {
      myApp = e("Frame", {
        ...
      }),
    })
  })
end
```
