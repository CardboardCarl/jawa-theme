local awful = require("awful")

awful.spawn.with_line_callback(
  [[bash -c "LC_ALL=C pactl subscribe"]],
  {
    stdout = function(line)
      -- Volume changed
      if line:match("on sink") or line:match("on source") then
        awesome.emit_signal("audio::volume_changed")
        awesome.emit_signal("microphone::volume_changed")
      end
      -- Device added/removed
      if line:match("on server") then
        awesome.emit_signal("audio::device_changed")
        awesome.emit_signal("microphone::device_changed")
      end
    end,
    output_done = function()
      -- Kill the pulseaudio subscribe command to prevent it from spawning multiple instances
      awful.spawn.with_shell("pkill pactl && pkill grep")
    end
  }
)

awesome.connect_signal(
  "exit",
  function()
    awful.spawn.with_shell("pkill pactl && pkill grep")
  end
)

awesome.connect_signal(
  "audio::volume_changed",
  function()
    awful.spawn.easy_async_with_shell(
      "./.config/awesome/src/scripts/vol.sh mute",
      function(stdout)
        local muted = false
        if stdout:match("yes") then
          muted = true
        end
        awful.spawn.easy_async_with_shell(
          "./.config/awesome/src/scripts/vol.sh volume",
          function(stdout2)
            awesome.emit_signal("audio::get", muted, stdout2:gsub("%%", ""):gsub("\n", "") or 0)
          end
        )
      end
    )
  end
)

awesome.connect_signal(
  "microphone::volume_changed",
  function()
    awful.spawn.easy_async_with_shell(
      "./.config/awesome/src/scripts/mic.sh mute",
      function(stdout)
        local muted = false
        if stdout:match("yes") then
          muted = true
        end
        awful.spawn.easy_async_with_shell(
          "./.config/awesome/src/scripts/mic.sh volume",
          function(stdout2)
            awesome.emit_signal("microphone::get", muted, stdout2:gsub("%%", ""):gsub("\n", "") or 0)
          end
        )
      end
    )
  end
)

awesome.emit_signal("audio::volume_changed")
awesome.emit_signal("microphone::volume_changed")
awesome.emit_signal("audio::device_changed")
awesome.emit_signal("microphone::device_changed")
