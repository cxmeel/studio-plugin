--!strict
--[=[
    @class Menu

    ```lua
    Roact.createElement(Menu, {
        id = "MyMenu",
        open = true,

        [Roact.Event.OnClose] = function(rbx: PluginMenu, result: PluginAction?)
            print("Menu closed with result:", result)
        end,
    }, {
        Roact.createElement(MenuItem, {
            id = "Item1",
            label = "Item 1",
            icon = 12345678,

            metadata = {
                item = 1,
                amount = 100,
            },

            [Roact.Event.Triggered] = function()
                print("Item 1 activated")
            end,
        }),

        Roact.createElement(MenuItem, {
            separator = true,
        }),

        Roact.createElement(MenuItem, {
            id = "CloseMenu",
            label = "Close Menu",
            icon = "rbxasset://textures/StudioSharedUI/clear.png",
        }),
    })
    ```
]=]
local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local tableUtil = require(script.Parent.Util.tableUtil)
local eventProps = require(script.Parent.Util.eventProps)

local Component = Roact.Component:extend("Menu")

--[=[
    @interface MenuProps
    @within Menu
    .id string -- The unique ID of the menu
    .open boolean? -- Whether the menu is open or not
]=]
export type MenuProps = {
	id: string,
	open: boolean?,
}

Component.defaultProps = {
	open = false,
}

function Component:init()
	local menu: PluginMenu = self.props.plugin:CreatePluginMenu(self.props.id)
	local events = eventProps.pick(self.props)

	function self.open()
		self.isOpen = true

		task.spawn(function()
			local result = menu:ShowAsync()

			self.isOpen = false

			if type(events.OnClose) == "function" then
				events.OnClose(menu, result)
			end

			if self.props.open == true then
				self.open()
			end
		end)
	end

	self.menu = menu
end

function Component:didMount()
	if self.props.open == true then
		self.open()
	end
end

function Component:willUnmount()
	self.menu:Destroy()
end

function Component:didUpdate(prev: MenuProps)
	if self.props.open ~= prev.open and self.props.open == true then
		self.open()
	end
end

function Component:render()
	if not (self.props.open or self.isOpen) then
		return nil
	end

	return Roact.createElement(Context.Menu.Provider, {
		value = {
			Instance = self.menu,
			open = self.open,
		},
	}, self.props[Roact.Children])
end

return function(props: MenuProps?)
	return Context.useContext(Context.Plugin, function(plugin: Plugin)
		return Roact.createElement(
			Component,
			tableUtil.merge({
				plugin = plugin,
			}, props)
		)
	end)
end
