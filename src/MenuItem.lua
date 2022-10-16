--!strict
--[=[
    @class MenuItem

    ```lua
    Roact.createElement(MenuItem, {
        id = "Item1",
        label = "Item 1",
        icon = 12345678,

        metadata = {
            item = 1,
            amount = 100,
        },

        [Roact.Event.Triggered] = function(item: PluginAction, metadata: unknown)
            print("Item 1 activated")
        end,
    })

    Roact.createElement(MenuItem, {
        separator = true,
    })
    ```
]=]
local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

local tableUtil = require(script.Parent.Util.tableUtil)
local eventProps = require(script.Parent.Util.eventProps)
local makeIcon = require(script.Parent.Util.makeIcon)

local Component = Roact.Component:extend("MenuItem")

--[=[
    @interface MenuItemProps
    @within MenuItem
    .id string? -- The unique ID of the menu item
    .label string? -- The label of the menu item
    .icon string? -- The icon of the menu item
    .separator boolean? -- Whether the menu item is a separator
    .metadata any? -- The metadata of the menu item

    Note that `id` is required if `separator` is false.
]=]
export type MenuItemProps = {
	label: string?,
	icon: string?,
	metadata: any?,
} & ({
	id: string,
	separator: false,
} | {
	id: string?,
	separator: true,
})

Component.defaultProps = {
	separator = false,
}

function Component:createMenuItem()
	local menu: PluginMenu = self.props.menu
	local item = self.item

	if item ~= nil then
		item:Destroy()
	end

	if self.props.separator then
		item = menu:AddSeparator()
	else
		item = menu:AddNewAction(self.props.id, self.props.label or self.props.id, makeIcon(self.props.icon))
		item.Triggered:Connect(self.onClick)
	end

	self.item = item
end

function Component:init()
	function self.onClick()
		local events = eventProps.pick(self.props)

		if events.Triggered ~= nil then
			events.Triggered(self.item, self.props.metadata)
		end
	end

	self:createMenuItem()
end

function Component:didUpdate(prev: MenuItemProps)
	if prev.separator ~= self.props.separator then
		self:createMenuItem()
		return
	end

	if self.props.separator then
		return
	end

	if prev.label ~= self.props.label then
		self:createMenuItem()
		return
	end

	if prev.icon ~= self.props.icon then
		self:createMenuItem()
		return
	end
end

function Component:willUnmount()
	if self.item ~= nil then
		self.item:Destroy()
	end
end

function Component:render()
	return nil
end

return function(props: MenuItemProps?)
	return Context.useContext(Context.Menu, function(menu: PluginMenu)
		return Roact.createElement(
			Component,
			tableUtil.merge({
				menu = menu,
			}, props)
		)
	end)
end
