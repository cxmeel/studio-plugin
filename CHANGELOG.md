# Changelog

## [1.1.0]

> **Important!** This release contains breaking changes.

In hindsight, StudioPlugin should've been released under `v0` to indicate that it was still in development. I apologise for any inconvenience this may cause.

### Added

- Documentation generated with moonwave is now available at https://csqrl.github.io/studio-plugin

### Changed

- Components now pass events through to the underlying Roblox instance (excluding `Plugin`&mdash;use hooks or `Context.useContext` to access the Plugin Instance)
- `StudioPlugin.Widget` now accepts a custom `OnInit` and `OnToggle` event, which replaces the `onInit` and `onToggle` props
- The structure of the `StudioPlugin` module has changed&mdash;components are directly inside the `src/` directory now, rather than `src/Components`
- Development dependencies are now managed with `aftman`

### Removed

- `StudioPlugin.Menu` and `StudioPlugin.MenuAction` components
- `Widget` component's `onToggle` and `onInit` props&mdash;please use the new custom events instead
