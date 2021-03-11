local SunCalc = require('suncalc/suncalc')
local toggled_manually = false
local is_night_set = false

local function get_lat_long()
    -- Paris is used as default lat/long
    local latitude = vim.g.theme_sunset_location_latitude or '48.864716'
    local longtitude = vim.g.theme_sunset_location_longtitude or '2.349014'
    return tonumber(latitude), tonumber(longtitude)
end

local function is_night()
    local latitude, longtitude = get_lat_long()
    local sc = SunCalc:new({ latitude = latitude, longtitude = longtitude })
    local _, altitude = sc:get_sun_pos()
    -- Sun sets at 0
    local threshold = tonumber(vim.g.theme_sunset_threshold) or 0
    return altitude < threshold
end

local function set_theme(is_night)
    local background
    local colorscheme
    if is_night then
        background = 'dark'
        colorscheme = vim.g.theme_sunset_colorscheme_dark
        is_night_set = true
    else
        background = 'light'
        colorscheme = vim.g.theme_sunset_colorscheme_light
        is_night_set = false
    end

    vim.api.nvim_set_option('background', background)
    if colorscheme ~= nil then
        vim.api.nvim_command(string.format('colorscheme %s', colorscheme))
    end
end

local function update_theme()
    if toggled_manually then
        return
    end

    set_theme(is_night())
end

local function toggle_theme()
    toggled_manually = true
    set_theme(not is_night_set)
end

local function reset()
    toggled_manually = false
    update_theme()
end

return {
    update_theme = update_theme,
    toggle_theme = toggle_theme,
    reset = reset,
}
