# Theme Sunset

Simple plugin that automatically switches theme from dark to light based on sun position.
It does not use any API to get information about current sun position, but relies on provided
latitude/longtitude, time and some smart calculations (variant of suncalc).

For plugin to work properly your latitude and longtitude has to be provided.

It works primarily by setting background option to 'dark' or 'light', but can also change colorscheme
as well.

The plugin also starts a timer task that runs indefinitely every 5 minutes that checks and updates
colorscheme and background.

## Configuration

Minimal required configuration is providing coordinates of your location.

```VimL
"Latitude/Longtitude
let g:theme_sunset_location_latitude='48.864716'
let g:theme_sunset_location_longtitude='2.349014'
```

Theme switch will happen when sun altitude is below/above 0. This can also be configured so that
"night" would last longer or shorter. By setting threshold above 0 - the theme will switch before
sun sets and after sun rises. If settings below 0 - the theme will switch after sun sets and before
sun rises.

```VimL
"Threshold
let g:theme_sunset_threshold=0
```

To also change colorscheme additional variables can be set.

```VimL
"Colorscheme during day
let g:theme_sunset_colorscheme_light='monokai'

"Colorscheme during night
let g:theme_sunset_colorscheme_dark='gruvbox'
```

## Commands

Plugin adds 3 commands that provide a way to manually update the theme, toggle the theme and reset.

```VimL
" Main function that updates theme based on sun altitude.
command! ThemeSunsetUpdate :lua theme_sunset.update_theme()

" Utility command that toggles theme. Doing this prevents regular updates,
" so that the toggle wouldn't be undone after 5 minutes (timer).
command! ThemeSunsetToggle :lua theme_sunset.toggle_theme()

" Resets the toggle and updates to correct theme based on current position.
" This is required after using ThemeSunsetToggle command to restore regular update
" mechanism.
command! ThemeSunsetReset :lua theme_sunset.reset()
```

## Installation

Using your favorite plugin installation method.

### vim-plug

An example of how to load this plugin using vim-plug:

```VimL
Plug 'hoffs/theme-sunset.nvim'
```

After running `:PlugInstall`, the files should appear in your `~/.config/nvim/plugged` directory (or whatever path you have configured for plugins).

## Credits

Lua Suncalc implementation by woodsnake at https://github.com/woodsnake/lua-suncalc
