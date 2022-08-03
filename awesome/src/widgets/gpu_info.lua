---------------------------------
-- This is the CPU Info widget --
---------------------------------

-- Awesome Libs
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

local icon_dir = awful.util.getdir("config") .. "src/assets/icons/cpu/"

return function(widget)
  local gpu_usage_widget = wibox.widget {
    {
      {
        {
          {
            {
              id = "icon",
              widget = wibox.widget.imagebox,
              valign = "center",
              halign = "center",
              image = gears.color.recolor_image(icon_dir .. "gpu.svg", Theme_config.gpu_usage.fg),
              resize = false
            },
            id = "icon_layout",
            widget = wibox.container.place
          },
          top = dpi(2),
          widget = wibox.container.margin,
          id = "icon_margin"
        },
        spacing = dpi(10),
        {
          id = "label",
          align = "center",
          valign = "center",
          widget = wibox.widget.textbox
        },
        id = "gpu_layout",
        layout = wibox.layout.fixed.horizontal
      },
      id = "container",
      left = dpi(8),
      right = dpi(8),
      widget = wibox.container.margin
    },
    bg = Theme_config.gpu_usage.bg,
    fg = Theme_config.gpu_usage.fg,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(6))
    end,
    widget = wibox.container.background
  }

  local gpu_temp_widget = wibox.widget {
    {
      {
        {
          {
            {
              id = "icon",
              widget = wibox.widget.imagebox,
              valign = "center",
              halign = "center",
              image = gears.color.recolor_image(icon_dir .. "cpu.svg", Theme_config.gpu_temp.fg),
              resize = false
            },
            id = "icon_layout",
            widget = wibox.container.place
          },
          top = dpi(2),
          widget = wibox.container.margin,
          id = "icon_margin"
        },
        spacing = dpi(10),
        {
          id = "label",
          align = "center",
          valign = "center",
          widget = wibox.widget.textbox
        },
        id = "gpu_layout",
        layout = wibox.layout.fixed.horizontal
      },
      id = "container",
      left = dpi(8),
      right = dpi(8),
      widget = wibox.container.margin
    },
    bg = Theme_config.gpu_temp.bg_low,
    fg = Theme_config.gpu_temp.fg,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(6))
    end,
    widget = wibox.container.background
  }

  Hover_signal(gpu_temp_widget)
  Hover_signal(gpu_usage_widget)

  -- GPU Utilization
  awesome.connect_signal(
    "update::gpu_usage",
    function(stdout)
      gpu_usage_widget.container.gpu_layout.label.text = stdout:gsub("\n", "") .. "%"
    end
  )

  -- GPU Temperature
  awesome.connect_signal(
    "update::gpu_temp",
    function(stdout)

      local temp_icon
      local temp_color
      local temp_num = tonumber(stdout) or "N/A"

      if temp_num then

        if temp_num < 50 then
          temp_color = Theme_config.gpu_temp.bg_low
          temp_icon = icon_dir .. "thermometer-low.svg"
        elseif temp_num >= 50 and temp_num < 80 then
          temp_color = Theme_config.gpu_temp.bg_mid
          temp_icon = icon_dir .. "thermometer.svg"
        elseif temp_num >= 80 then
          temp_color = Theme_config.gpu_temp.bg_high
          temp_icon = icon_dir .. "thermometer-high.svg"
        end
      else
        temp_num = "N/A"
        temp_color = Theme_config.gpu_temp.bg_low
        temp_icon = icon_dir .. "thermometer-low.svg"
      end
      gpu_temp_widget.container.gpu_layout.icon_margin.icon_layout.icon:set_image(temp_icon)
      gpu_temp_widget:set_bg(temp_color)
      gpu_temp_widget.container.gpu_layout.label.text = tostring(temp_num) .. "°C"
    end
  )

  if widget == "usage" then
    return gpu_usage_widget
  elseif widget == "temp" then
    return gpu_temp_widget
  end
end
