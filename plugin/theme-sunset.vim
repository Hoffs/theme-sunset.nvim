lua theme_sunset = require("theme-sunset")

command! ThemeSunsetUpdate :lua theme_sunset.update_theme()
command! ThemeSunsetToggle :lua theme_sunset.toggle_theme()
command! ThemeSunsetReset :lua theme_sunset.reset()

func ThemeSunsetUpdateHandler(timer)
  lua theme_sunset.update_theme()
endfunc

lua theme_sunset.update_theme()
let timer_interval = 5 * 60 * 1000
let timer = timer_start(timer_interval, 'ThemeSunsetUpdateHandler', {'repeat': -1})
