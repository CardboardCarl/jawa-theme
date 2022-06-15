---@diagnostic disable: undefined-field
-- Awesome Libs
local awful = require("awful")
local gears = require("gears")

screen.connect_signal(
  "added",
  function()
    awesome.restart()
  end
)

screen.connect_signal(
  "removed",
  function()
    awesome.restart()
  end
)

client.connect_signal(
  "manage",
  function(c)
    if awesome.startup and not c.size_hints.user_porition and not c.size_hints.program_position then
      awful.placement.no_offscreen(c)
    end
    c.shape = function(cr, width, height)
      if c.fullscreen or c.maximized then
        gears.shape.rectangle(cr, width, height)
      else
        gears.shape.rounded_rect(cr, width, height, 10)
      end
    end
  end
)

client.connect_signal(
  'unmanage',
  function(c)
    if #awful.screen.focused().clients > 0 then
      awful.screen.focused().clients[1]:emit_signal(
        'request::activate',
        'mouse_enter',
        {
          raise = true
        }
      )
    end
  end
)

tag.connect_signal(
  'property::selected',
  function(c)
    if #awful.screen.focused().clients > 0 then
      awful.screen.focused().clients[1]:emit_signal(
        'request::activate',
        'mouse_enter',
        {
          raise = true
        }
      )
    end
  end
)

-- Sloppy focus
client.connect_signal(
  "mouse::enter",
  function(c)
    c:emit_signal(
      "request::activate",
      "mouse_enter",
      {
        raise = false
      }
    )
  end
)

--- Takes a wibox.container.background and connects four signals to it
---@diagnostic disable-next-line: undefined-doc-name
---@param widget widget.container.background
---@param bg string
---@param fg string
function Hover_signal(widget, bg, fg)
  local old_wibox, old_cursor, old_bg, old_fg

  local mouse_enter = function()
    if bg then
      old_bg = widget.bg
      if string.len(bg) == 7 then
        widget.bg = bg .. 'dd'
      else
        widget.bg = bg
      end
    end
    if fg then
      old_fg = widget.fg
      widget.fg = fg
    end
    local w = mouse.current_wibox
    if w then
      old_cursor, old_wibox = w.cursor, w
      w.cursor = "hand1"
    end
  end

  local button_press = function()
    if bg then
      if bg then
        if string.len(bg) == 7 then
          widget.bg = bg .. 'bb'
        else
          widget.bg = bg
        end
      end
    end
    if fg then
      widget.fg = fg
    end
  end

  local button_release = function()
    if bg then
      if bg then
        if string.len(bg) == 7 then
          widget.bg = bg .. 'dd'
        else
          widget.bg = bg
        end
      end
    end
    if fg then
      widget.fg = fg
    end
  end

  local mouse_leave = function()
    if bg then
      widget.bg = old_bg
    end
    if fg then
      widget.fg = old_fg
    end
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end

  widget:disconnect_signal("mouse::enter", mouse_enter)

  widget:disconnect_signal("button::press", button_press)

  widget:disconnect_signal("button::release", button_release)

  widget:disconnect_signal("mouse::leave", mouse_leave)

  widget:connect_signal("mouse::enter", mouse_enter)

  widget:connect_signal("button::press", button_press)

  widget:connect_signal("button::release", button_release)

  widget:connect_signal("mouse::leave", mouse_leave)

end
