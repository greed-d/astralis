# Quickshell Bar

A status bar built with Quickshell. Currently in early development.

## Status

Only the network module is implemented right now. Everything else described below is planned but not yet built.

## Implemented

- Network module: shows current network status (connection state, interface, signal strength)

## TODO

Modules not yet implemented, in suggested build order.

- [ ] Clock and date module
- [ ] Workspaces / window manager module
- [ ] System tray
- [ ] Volume / audio module
- [ ] Battery module
- [ ] CPU and memory usage module
- [ ] Notifications module
- [ ] Media player controls

## Requirements

- Quickshell
- Qt (matching the version Quickshell depends on)
- A Wayland compositor Quickshell supports (e.g. Hyprland, Sway)

## Installation

1. Clone this repository into your Quickshell config directory.
2. Adjust paths in the config as needed for your system.
3. Launch Quickshell pointing at this config.

## Configuration

As described, module-specific configuration will be added as modules are added. Right now, only the network module has configurable options.

## Roadmap

This document outlines the direction for the Quickshell bar. The end goal is to turn it into a multipurpose dynamic pill, a single compact widget that expands and contracts to show different modules depending on context, rather than a traditional fixed bar with separate sections.

### Current State

- Network module only
- Bar is laid out as a standard static bar, not yet a pill

### Phase 1: Core Modules

Build out the basic bar functionality with individual modules, each working independently.

- Clock and date module
- Workspace / window manager indicator
- System tray
- Volume module
- Battery module
- CPU and memory usage module

Goal: reach feature parity with a typical status bar before reworking the shape and behavior.

### Phase 2: Module Framework

Refactor modules into a consistent, reusable structure so new modules can be added without duplicating layout, styling, or state handling code.

- Shared module interface (consistent props, sizing, and state handling)
- Shared styling and theming system
- Central config for enabling and ordering modules
- Consistent hover and click behavior across modules

### Phase 3: Dynamic Pill Shape

Rework the bar's visual container from a fixed rectangular bar into a pill shape that resizes based on content.

- Pill container that grows and shrinks based on active module width
- Smooth resize and morph animations between states
- Idle state showing a compact default view (e.g. clock or nothing at all)
- Active state expanding to show the relevant module in more detail

### Phase 4: Contextual Behavior

Make the pill respond to system state rather than always showing everything at once.

- Auto-expand on events (e.g. volume change, network state change, new notification)
- Auto-collapse after a timeout of inactivity
- Priority system for when multiple modules want attention at once
- Click or hover to expand and reveal secondary details or controls

### Phase 5: Interactivity

Turn modules from passive indicators into small interactive panels within the pill.

- Volume module with a slider on expand
- Network module with a list of available networks on expand
- Media module with playback controls on expand
- Notification module with a list of recent notifications on expand

### Phase 6: Polish

- Theming support (light, dark, custom color schemes)
- Per-monitor configuration for multi-monitor setups
- Configurable module order and visibility per user
- Performance pass to keep animations smooth on lower end hardware
- Documentation for writing custom modules

### Open Questions

- Should the pill live at a fixed screen position, or be draggable
- How much state should persist across restarts (e.g. last expanded module)
- Whether modules should be Quickshell-native or allow external scripts


## Contributing

This project is early stage. Issues and pull requests are welcome, especially for new modules.

## License


