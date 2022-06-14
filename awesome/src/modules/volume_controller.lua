-----------------------------------
-- This is the volume controller --
-----------------------------------

-- Awesome Libs
local awful = require("awful")
local color = require("src.theme.colors")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

local rubato = require("src.lib.rubato")

-- Icon directory path
local icondir = awful.util.getdir("config") .. "src/assets/icons/audio/"

-- Returns the volume controller
return function(s)

  -- Function to create source/sink devices
  local function create_device(name, node, sink)
    local device = wibox.widget {
      {
        {
          {
            id = "icon",
            resize = false,
            valign = "center",
            halign = "center",
            widget = wibox.widget.imagebox
          },
          spacing = dpi(10),
          {
            text = name,
            id = "node",
            widget = wibox.widget.textbox
          },
          id = "device_layout",
          layout = wibox.layout.fixed.horizontal
        },
        id = "device_margin",
        margins = dpi(9),
        widget = wibox.container.margin
      },
      id = "background",
      bg = color["Grey900"],
      border_color = color["Grey800"],
      border_width = dpi(2),
      shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(4))
      end,
      widget = wibox.container.background
    }
    if sink == true then
      device:connect_signal(
        "button::press",
        function()
          if node then
            awful.spawn("./.config/awesome/src/scripts/vol.sh set_sink " .. node)
          end
          awesome.emit_signal("update::bg_sink", node)
        end
      )
      awesome.connect_signal(
        "update::bg_sink",
        function(new_node)
          if node == new_node then
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "headphones.svg",
              color["Grey900"])
            device.bg = color["Purple200"]
            device.fg = color["Grey900"]
          else
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "headphones.svg",
              color["Purple200"])
            device.bg = color["Grey900"]
            device.fg = color["Purple200"]
          end
        end
      )
      awful.spawn.easy_async_with_shell(
        [[ pactl get-default-sink ]],
        function(stdout)
          local node_active = stdout:gsub("\n", "")
          if node == node_active then
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "headphones.svg",
              color["Grey900"])
            device.bg = color["Purple200"]
            device.fg = color["Grey900"]
          else
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "headphones.svg",
              color["Purple200"])
            device.bg = color["Grey900"]
            device.fg = color["Purple200"]
          end
        end
      )
      awesome.emit_signal("update::bg_sink", node)
    else

      device:connect_signal(
        "button::press",
        function()
          if node then
            awful.spawn("./.config/awesome/src/scripts/mic.sh set_source " .. node)
          end
          awesome.emit_signal("update::bg_source", node)
        end
      )
      awesome.connect_signal(
        "update::bg_source",
        function(new_node)
          if node == new_node then
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "microphone.svg",
              color["Grey900"])
            device.bg = color["Blue200"]
            device.fg = color["Grey900"]
          else
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "microphone.svg",
              color["Blue200"])
            device.bg = color["Grey900"]
            device.fg = color["Blue200"]
          end
        end
      )
      awful.spawn.easy_async_with_shell(
        [[ pactl get-default-source ]],
        function(stdout)
          local node_active = stdout:gsub("\n", "")
          if node == node_active then
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "microphone.svg",
              color["Grey900"])
            device.bg = color["Blue200"]
            device.fg = color["Grey900"]
          else
            device:get_children_by_id("icon")[1].image = gears.color.recolor_image(icondir .. "microphone.svg",
              color["Blue200"])
            device.bg = color["Grey900"]
            device.fg = color["Blue200"]
          end
        end
      )
      awesome.emit_signal("update::bg_source", node)
    end
    return device
  end

  -- Container for the source devices
  local dropdown_list_volume = wibox.widget {
    {
      {
        {
          {
            spacing = dpi(10),
            layout = wibox.layout.overflow.vertical,
            scrollbar_width = 0,
            step = dpi(50),
            id = "volume_device_list",
          },
          id = "margin",
          margins = dpi(10),
          widget = wibox.container.margin
        },
        id = "place",
        height = dpi(200),
        strategy = "max",
        widget = wibox.container.constraint
      },
      border_color = color["Grey800"],
      border_width = dpi(2),
      id = "volume_device_background",
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, dpi(4))
      end,
      widget = wibox.container.background
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
  }

  -- Container for the sink devices
  local dropdown_list_microphone = wibox.widget {
    {
      {
        {
          {
            spacing = dpi(10),
            layout = wibox.layout.overflow.vertical,
            id = "volume_device_list",
            scrollbar_width = 0,
            step = dpi(50),
          },
          id = "margin",
          margins = dpi(10),
          widget = wibox.container.margin
        },
        id = "place",
        height = dpi(200),
        strategy = "max",
        widget = wibox.container.constraint
      },
      id = "volume_device_background",
      border_color = color["Grey800"],
      border_width = dpi(2),
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, dpi(4))
      end,
      widget = wibox.container.background
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
  }

  local volume_controller = wibox.widget {
    {
      {
        -- Audio Device selector
        {
          {
            {
              {
                {
                  resize = false,
                  image = gears.color.recolor_image(icondir .. "menu-down.svg", color["Purple200"]),
                  widget = wibox.widget.imagebox,
                  valign = "center",
                  halign = "center",
                  id = "icon"
                },
                id = "center",
                halign = "center",
                valign = "center",
                widget = wibox.container.place,
              },
              {
                {
                  text = "Output Device",
                  widget = wibox.widget.textbox,
                  id = "device_name"
                },
                margins = dpi(5),
                widget = wibox.container.margin
              },
              id = "audio_volume",
              layout = wibox.layout.fixed.horizontal
            },
            id = "audio_bg",
            bg = color["Grey800"],
            fg = color["Purple200"],
            shape = function(cr, width, height)
              gears.shape.rounded_rect(cr, width, height, dpi(4))
            end,
            widget = wibox.container.background
          },
          id = "audio_selector_margin",
          left = dpi(10),
          right = dpi(10),
          top = dpi(10),
          widget = wibox.container.margin
        },
        {
          id = "volume_list",
          widget = dropdown_list_volume,
          forced_height = 0
        },
        -- Microphone selector
        {
          {
            {
              {
                {
                  resize = false,
                  image = gears.color.recolor_image(icondir .. "menu-down.svg", color["LightBlueA200"]),
                  widget = wibox.widget.imagebox,
                  valign = "center",
                  halign = "center",
                  id = "icon",
                },
                id = "center",
                halign = "center",
                valign = "center",
                widget = wibox.container.place,
              },
              {
                {
                  text = "Input Device",
                  widget = wibox.widget.textbox,
                  id = "device_name"
                },
                margins = dpi(5),
                widget = wibox.container.margin
              },
              id = "mic_volume",
              layout = wibox.layout.fixed.horizontal
            },
            id = "mic_bg",
            bg = color["Grey800"],
            fg = color["LightBlueA200"],
            shape = function(cr, width, height)
              gears.shape.rounded_rect(cr, width, height, dpi(4))
            end,
            widget = wibox.container.background
          },
          id = "mic_selector_margin",
          left = dpi(10),
          right = dpi(10),
          top = dpi(10),
          widget = wibox.container.margin
        },
        {
          id = "mic_list",
          widget = dropdown_list_microphone,
          forced_height = 0
        },
        -- Audio volume slider
        {
          {
            {
              resize = false,
              widget = wibox.widget.imagebox,
              valign = "center",
              halign = "center",
              image = gears.color.recolor_image(icondir .. "volume-high.svg", color["Purple200"]),
              id = "icon",
            },
            {
              {
                bar_shape = function(cr, width, height)
                  gears.shape.rounded_rect(cr, width, height, dpi(5))
                end,
                bar_height = dpi(5),
                bar_color = color["Grey800"],
                bar_active_color = color["Purple200"],
                handle_color = color["Purple200"],
                handle_shape = gears.shape.circle,
                handle_border_color = color["Purple200"],
                handle_width = dpi(12),
                maximum = 100,
                forced_height = dpi(26),
                widget = wibox.widget.slider,
                id = "slider"
              },
              left = dpi(5),
              id = "slider_margin",
              widget = wibox.container.margin
            },
            id = "audio_volume",
            layout = wibox.layout.align.horizontal
          },
          id = "audio_volume_margin",
          top = dpi(10),
          left = dpi(10),
          right = dpi(10),
          widget = wibox.container.margin
        },
        -- Microphone volume slider
        {
          {
            {
              resize = false,
              widget = wibox.widget.imagebox,
              valign = "center",
              halign = "center",
              image = gears.color.recolor_image(icondir .. "microphone.svg", color["Blue200"]),
              id = "icon"
            },
            {
              {
                bar_shape = function(cr, width, height)
                  gears.shape.rounded_rect(cr, width, height, dpi(5))
                end,
                bar_height = dpi(5),
                bar_color = color["Grey800"],
                bar_active_color = color["Blue200"],
                handle_color = color["Blue200"],
                handle_shape = gears.shape.circle,
                handle_border_color = color["Blue200"],
                handle_width = dpi(12),
                maximum = 100,
                forced_height = dpi(26),
                widget = wibox.widget.slider,
                id = "slider"
              },
              left = dpi(5),
              id = "slider_margin",
              widget = wibox.container.margin
            },
            id = "mic_volume",
            layout = wibox.layout.align.horizontal
          },
          id = "mic_volume_margin",
          left = dpi(10),
          right = dpi(10),
          top = dpi(10),
          widget = wibox.container.margin
        },
        id = "controller_layout",
        layout = wibox.layout.fixed.vertical
      },
      id = "controller_margin",
      margins = dpi(10),
      widget = wibox.container.margin
    },
    bg = color["Grey900"],
    border_color = color["Grey800"],
    border_width = dpi(4),
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    forced_width = dpi(400),
    widget = wibox.container.background
  }

  -- Variables for easier access and better readability
  local audio_selector_margin = volume_controller:get_children_by_id("audio_selector_margin")[1]
  local volume_list = volume_controller:get_children_by_id("volume_list")[1]
  local audio_bg = volume_controller:get_children_by_id("audio_bg")[1]
  local audio_volume = volume_controller:get_children_by_id("audio_volume")[1].center

  -- Click event for the audio dropdown
  audio_selector_margin:connect_signal(
    "button::press",
    function()
      local rubato_timer = rubato.timed {
        duration = 0.4,
        intro = 0.1,
        outro = 0.1,
        pos = volume_list.forced_height,
        easing = rubato.linear,
        subscribed = function(v)
          volume_list.forced_height = v
        end
      }
      if volume_list.forced_height == 0 then
        rubato_timer.target = dpi(200)
        audio_bg.shape = function(cr, width, height)
          gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, dpi(4))
        end
        audio_volume.icon:set_image(gears.color.recolor_image(icondir .. "menu-up.svg", color["Purple200"]))
      else
        rubato_timer.target = 0
        audio_bg.shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, dpi(4))
        end
        audio_volume.icon:set_image(gears.color.recolor_image(icondir .. "menu-down.svg", color["Purple200"]))
      end
    end
  )

  -- Variables for easier access and better readability
  local mic_selector_margin = volume_controller:get_children_by_id("mic_selector_margin")[1]
  local mic_list = volume_controller:get_children_by_id("mic_list")[1]
  local mic_bg = volume_controller:get_children_by_id("mic_bg")[1]
  local mic_volume = volume_controller:get_children_by_id("mic_volume")[1].center

  -- Click event for the microphone dropdown
  mic_selector_margin:connect_signal(
    "button::press",
    function()
      local rubato_timer = rubato.timed {
        duration = 0.4,
        intro = 0.1,
        outro = 0.1,
        pos = mic_list.forced_height,
        easing = rubato.linear,
        subscribed = function(v)
          mic_list.forced_height = v
        end
      }
      if mic_list.forced_height == 0 then
        rubato_timer.target = dpi(200)
        mic_selector_margin.mic_bg.shape = function(cr, width, height)
          gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, dpi(4))
        end
        mic_volume.icon:set_image(gears.color.recolor_image(icondir .. "menu-up.svg", color["Blue200"]))
      else
        rubato_timer.target = 0
        mic_bg.shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, dpi(4))
        end
        mic_volume.icon:set_image(gears.color.recolor_image(icondir .. "menu-down.svg", color["Blue200"]))
      end
    end
  )

  local audio_slider_margin = volume_controller:get_children_by_id("audio_volume_margin")[1].audio_volume.slider_margin.
      slider

  -- Volume slider change event
  audio_slider_margin:connect_signal(
    "property::value",
    function()
      local volume = audio_slider_margin.value
      awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ " .. tonumber(volume) .. "%")
    end
  )

  local mic_slider_margin = volume_controller:get_children_by_id("mic_volume_margin")[1].mic_volume.slider_margin.slider

  -- Microphone slider change event
  mic_slider_margin:connect_signal(
    "property::value",
    function()
      local volume = mic_slider_margin.value
      awful.spawn("pactl set-source-volume @DEFAULT_SOURCE@ " .. tonumber(volume) .. "%")
      awesome.emit_signal("get::mic_volume", volume)
    end
  )

  -- Main container
  local volume_controller_container = awful.popup {
    widget = wibox.container.background,
    ontop = true,
    bg = color["Grey900"],
    stretch = false,
    visible = false,
    screen = s,
    placement = function(c) awful.placement.align(c,
        { position = "top_right", margins = { right = dpi(305), top = dpi(60) } })
    end,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, dpi(12))
    end
  }

  -- Get all source devices
  local function get_source_devices()
    awful.spawn.easy_async_with_shell(
      [[ 
        pactl list sinks | grep -E 'node.name|device.description|alsa.card_name' | awk '{gsub(/"/, ""); for(i = 1;i < NF;i++) printf $i " "; print $NF}'
      ]],
      function(stdout)
        local device_list = {}
        local was_alsa = false
        local node_names, alsa_names = {}, {}
        for val in stdout:gmatch("[^\n]+") do
          if val:match("alsa%.card_name") then
            table.insert(alsa_names, val:match("alsa%.card_name%s=%s(.*)"))
            was_alsa = true
          elseif val:match("device%.description") and not was_alsa then
            table.insert(alsa_names, val:match("device%.description%s=%s(.*)"))
            was_alsa = false
          else
            was_alsa = false
          end

          if val:match("node%.name") then
            table.insert(node_names, val:match("node%.name%s=%s(.*)"))
          end
        end

        for k = 1, #alsa_names, 1 do
          device_list[#device_list + 1] = create_device(alsa_names[k], node_names[k], true)
        end
        dropdown_list_volume:get_children_by_id("volume_device_list")[1].children = device_list
      end
    )
  end

  get_source_devices()

  -- Get all input devices
  local function get_input_devices()
    awful.spawn.easy_async_with_shell(
      [[ 
        pactl list sources | grep -E "node.name|device.description|alsa.card_name" | awk '{gsub(/"/, ""); for(i = 1;i < NF;i++) printf $i " "; print $NF}'
      ]],
      function(stdout)
        local device_list = {}
        local was_alsa = false
        local node_names, alsa_names = {}, {}

        for val in stdout:gmatch("[^\n]+") do
          if val:match("alsa%.card_name") then
            table.insert(alsa_names, val:match("alsa%.card_name%s=%s(.*)"))
            was_alsa = true
          elseif val:match("device%.description") and not was_alsa then
            table.insert(alsa_names, val:match("device%.description%s=%s(.*)"))
            was_alsa = false
          else
            was_alsa = false
          end

          if val:match("node%.name") then
            table.insert(node_names, val:match("node%.name%s=%s(.*)"))
          end
        end

        for k = 1, #alsa_names, 1 do
          device_list[#device_list + 1] = create_device(alsa_names[k], node_names[k], false)
        end
        dropdown_list_microphone:get_children_by_id("volume_device_list")[1].children = device_list
      end
    )
  end

  get_input_devices()

  -- Event watcher, detects when device is addes/removed
  awful.spawn.with_line_callback(
    [[bash -c "LC_ALL=C pactl subscribe | grep --line-buffered 'on server'"]],
    {
      stdout = function(line)
        get_input_devices()
        get_source_devices()
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

  -- Get microphone volume
  local function get_mic_volume()
    awful.spawn.easy_async_with_shell(
      "./.config/awesome/src/scripts/mic.sh volume",
      function(stdout)
        local volume = stdout:gsub("%%", ""):gsub("\n", "")
        volume_controller:get_children_by_id("mic_volume_margin")[1].mic_volume.slider_margin.slider:set_value(tonumber(volume))
        if volume > 0 then
          volume_controller:get_children_by_id("mic_volume_margin")[1].icon:set_image(gears.color.recolor_image(icondir
            .. "microphone.svg", color["LightBlue200"]))
        else
          volume_controller:get_children_by_id("mic_volume_margin")[1].icon:set_image(gears.color.recolor_image(icondir
            .. "microphone-off.svg", color["LightBlue200"]))
        end
      end
    )
  end

  get_mic_volume()

  -- Check if microphone is muted
  local function get_mic_mute()
    awful.spawn.easy_async_with_shell(
      "./.config/awesome/src/scripts/mic.sh mute",
      function(stdout)
        if stdout:match("yes") then
          volume_controller:get_children_by_id("mic_volume_margin")[1].mic_volume.slider_margin.slider:set_value(tonumber(0))
          volume_controller:get_children_by_id("mic_volume_margin")[1].icon:set_image(gears.color.recolor_image(icondir
            .. "microphone-off.svg", color["LightBlue200"]))
        else
          get_mic_volume()
        end
      end
    )
  end

  get_mic_mute()

  -- When the mouse leaves the popup it stops the mousegrabber and hides the popup.
  volume_controller_container:connect_signal(
    "mouse::leave",
    function()
      mousegrabber.run(
        function()
          awesome.emit_signal("volume_controller::toggle", s)
          mousegrabber.stop()
          return true
        end,
        "arrow"
      )
    end
  )

  volume_controller_container:connect_signal(
    "mouse::enter",
    function()
      mousegrabber.stop()
    end
  )

  -- Grabs all keys and hides popup when anything is pressed
  -- TODO: Make it possible to navigate and select using the kb
  awful.keygrabber {
    autostart = false,
    stop_event = 'release',
    keypressed_callback = function()
      awesome.emit_signal("volume_controller::toggle", s)
      mousegrabber.stop()
    end
  }

  -- Draw the popup
  volume_controller_container:setup {
    volume_controller,
    layout = wibox.layout.fixed.horizontal
  }

  -- Set the volume and icon
  awesome.connect_signal(
    "get::volume",
    function(volume)
      volume = tonumber(volume)
      local icon = icondir .. "volume"
      if volume < 1 then
        icon = icon .. "-mute"

      elseif volume >= 1 and volume < 34 then
        icon = icon .. "-low"
      elseif volume >= 34 and volume < 67 then
        icon = icon .. "-medium"
      elseif volume >= 67 then
        icon = icon .. "-high"
      end

      volume_controller.controller_margin.controller_layout.audio_volume_margin.audio_volume.slider_margin.slider:
          set_value(volume)
      volume_controller.controller_margin.controller_layout.audio_volume_margin.audio_volume.icon:set_image(gears.color.
        recolor_image(icon .. ".svg", color["Purple200"]))
    end
  )

  -- Check if the volume is muted
  awesome.connect_signal(
    "get::volume_mute",
    function(mute)
      if mute then
        volume_controller.controller_margin.controller_layout.audio_volume_margin.audio_volume.icon:set_image(gears.
          color.recolor_image(icondir .. "volume-mute.svg", color["Purple200"]))
      end
    end
  )

  -- Set the microphone volume
  awesome.connect_signal(
    "get::mic_volume",
    function(volume)
      if volume > 0 then
        volume_controller:get_children_by_id("mic_volume_margin")[1].mic_volume.icon:set_image(gears.color.recolor_image(icondir
          .. "microphone.svg", color["LightBlue200"]))
        awesome.emit_signal("update::microphone_widget", tonumber(volume), icondir .. "microphone.svg")
      else
        volume_controller:get_children_by_id("mic_volume_margin")[1].mic_volume.icon:set_image(gears.color.recolor_image(icondir
          .. "microphone-off.svg", color["LightBlue200"]))
        awesome.emit_signal("update::microphone_widget", tonumber(volume), icondir .. "microphone-off.svg")
      end
    end
  )

  -- Toggle container visibility
  awesome.connect_signal(
    "volume_controller::toggle",
    function(scr)
      if scr == s then
        volume_controller_container.visible = not volume_controller_container.visible
      end

    end
  )

end
