--------------------------------------------------------------------------------------------------------------
-- This is the statusbar, every widget, module and so on is combined to all the stuff you see on the screen --
--------------------------------------------------------------------------------------------------------------
-- Awesome Libs
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

return function(s, w)

  local function prepare_widgets(widgets)
    local layout = {
      forced_height = dpi(50),
      layout = wibox.layout.fixed.horizontal
    }
    for i, widget in pairs(widgets) do
      if i == 1 then
        table.insert(layout,
          {
            widget,
            left = dpi(6),
            right = dpi(3),
            top = dpi(6),
            bottom = dpi(6),
            widget = wibox.container.margin
          })
      elseif i == #widgets then
        table.insert(layout,
          {
            widget,
            left = dpi(3),
            right = dpi(6),
            top = dpi(6),
            bottom = dpi(6),
            widget = wibox.container.margin
          })
      else
        table.insert(layout,
          {
            widget,
            left = dpi(3),
            right = dpi(3),
            top = dpi(6),
            bottom = dpi(6),
            widget = wibox.container.margin
          })
      end
    end
    return layout
  end

  local top_right = awful.popup {
    widget = prepare_widgets(w),
    ontop = false,
    bg = Theme_config.right_bar.bg,
    visible = true,
    screen = s,
    placement = function(c) awful.placement.top_right(c, { margins = dpi(10) }) end,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(6))
    end
  }

  top_right:struts {
    top = dpi(55)
  }

  Global_config.top_struts = top_right
end
