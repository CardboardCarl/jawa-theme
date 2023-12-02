local setmetatable = setmetatable

-- Awesome Libs
local abutton = require('awful.button')
local alayout = require('awful.layout')
local awidget = require('awful.widget')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local gtable = require('gears.table')
local wibox = require('wibox')

<<<<<<< HEAD
-- Returns the layoutbox widget
return function(s)
  local layout = wibox.widget {
    {
      {
        awful.widget.layoutbox(s),
        id = "icon_layout",
        widget = wibox.container.place
      },
      id = "icon_margin",
      left = dpi(5),
      right = dpi(5),
      forced_width = dpi(40),
      widget = wibox.container.margin
    },
    bg = color["LightBlue200"],
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 5)
    end,
    widget = wibox.container.background,
    screen = s
  }
=======
-- Local libs
local hover = require('src.tools.hover')

return setmetatable({}, {
  __call = function(_, screen)
    local layout = wibox.widget {
      {
        {
          {
            awidget.layoutbox(),
            widget = wibox.container.place,
          },
          left = dpi(5),
          right = dpi(5),
          widget = wibox.container.margin,
        },
        widget = wibox.container.constraint,
        strategy = 'exact',
        width = dpi(40),
      },
      bg = beautiful.colorscheme.bg_blue,
      shape = beautiful.shape[6],
      widget = wibox.container.background,
    }
>>>>>>> develop

    hover.bg_hover { widget = layout }

<<<<<<< HEAD
  layout:connect_signal(
    "button::press",
    function()
      awful.layout.inc(-1, s)
    end
  )
=======
    layout:buttons(gtable.join(
      abutton({}, 1, function()
        alayout.inc(1, screen)
      end),
      abutton({}, 3, function()
        alayout.inc(-1, screen)
      end),
      abutton({}, 4, function()
        alayout.inc(1, screen)
      end),
      abutton({}, 5, function()
        alayout.inc(-1, screen)
      end)
    ))
>>>>>>> develop

    return layout
  end,
})
