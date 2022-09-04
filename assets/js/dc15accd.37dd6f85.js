"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[151],{28480:e=>{e.exports=JSON.parse('{"functions":[{"name":"useContext","desc":"A function that returns a component that will render the\\ngiven render function with the value of the context. This\\nis useful for consuming contexts in a component, where\\nyou cannot use hooks.","params":[{"name":"context","desc":"","lua_type":"Roact.Context"},{"name":"render","desc":"","lua_type":"(value: T) -> Roact.Element"}],"returns":[{"desc":"","lua_type":"Roact.Element"}],"function_type":"static","source":{"line":30,"path":"src/Context.lua"}}],"properties":[{"name":"Plugin","desc":"The plugin context. This is the [plugin][Plugin] that the app is\\nrunning in. This is automatically detected, providing\\nthat this module is installed within the plugin itself.\\n\\nIf you have installed this module outside of the plugin,\\nyou can use the Plugin component to provide the plugin\\ninstance.","lua_type":"Roact.Context<Plugin>","source":{"line":50,"path":"src/Context.lua"}},{"name":"Toolbar","desc":"The toolbar context. This is the [toolbar][PluginToolbar] that the\\nbuttons are added to.","lua_type":"Roact.Context<PluginToolbar>","source":{"line":59,"path":"src/Context.lua"}},{"name":"Widget","desc":"The widget context. This is the [widget][DockWidgetPluginGui] that\\nthe app is rendered inside of.","lua_type":"Roact.Context<DockWidgetPluginGui>","source":{"line":68,"path":"src/Context.lua"}}],"types":[],"name":"Context","desc":"Provides context to the Roact app. This enables the app\\nto access the current plugin/widget/toolbar/etc. from\\nanywhere below the root component.","source":{"line":9,"path":"src/Context.lua"}}')}}]);