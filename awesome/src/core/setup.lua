--- A module to manage the first installation and setup the config without having to edit
--- the config files manually.

--Awesome Libs
local abutton = require("awful.button")
local aplacement = require("awful.placement")
local apopup = require("awful.popup")
local aspawn = require("awful.spawn")
local atooltip = require("awful.tooltip")
local awidget = require("awful.widget")
local dpi = require("beautiful").xresources.apply_dpi
local gcolor = require("gears.color")
local gtable = require("gears.table")
local wibox = require("wibox")

--Own Libs
local toggle_button = require("awful.widget.toggle_widget")

local capi = {
  screen = screen,
}

local assets_dir = os.getenv("HOME") .. "/.config/awesome/src/assets/"
local font_dir = os.getenv("HOME") .. "/.config/awesome/src/assets/fonts/"
local icon_dir = os.getenv("HOME") .. "/.config/awesome/src/assets/icons/setup/"

local setup = { mt = {} }

local widget_list = {
  "Audio",
  "Battery",
  "Bluetooth",
  "Clock",
  "Cpu Frequency",
  "Cpu Temperature",
  "Cpu Usage",
  "Date",
  "Gpu Temperature",
  "Gpu Usage",
  "Keyboard Layout",
  "Tiling Layout",
  "Network",
  "Power Button",
  "Ram Usage",
  "Systray",
  "Taglist",
  "Tasklist",
}

local statusbar_list = {
  "Battery",
  "Backlight",
  "CPU Temp",
  "CPU Usage",
  "GPU Temp",
  "GPU Usage",
  "Microphone",
  "RAM",
  "Volume"
}

--[[
  Creates the pages for the setup module
  1. Welcome, short explanation and thanking for downloading
  2. Selecting the wallpaper
  3. Selecting the bar and widgets
  4. Selecting the Notification Center widgets and weather
  5. Choose/change default programs
  6. Setup tiling layouts
  7. Titlebar settings
  8. Font and Icon theme
  9. Final page, with a button to restart awesome
]]
local function create_pages()
  local pages = {}
  table.insert(pages, setup:welcome_page())
  table.insert(pages, setup:wallpaper_page())
  table.insert(pages, setup:bar_page())
  table.insert(pages, setup:notification_page())
  table.insert(pages, setup:programs_page())
  table.insert(pages, setup:layouts_page())
  table.insert(pages, setup:titlebar_page())
  table.insert(pages, setup:font_page())
  table.insert(pages, setup:final_page())
  return pages
end

--- The first page, with a short explanation and thanking for downloading
function setup:welcome_page()
  return wibox.widget {
    {
      { -- Left side with text etc
        {
          {
            {
              {
                widget = wibox.widget.textbox,
                markup = "Welcome to Crylia-Theme",
                font = "Raleway Bold 36",
                halign = "left",
                valign = "center"
              },
              {
                widget = wibox.widget.textbox,
                markup = "Thank you for downloading Crylia-Theme, a beautiful and customizable config for AwesomeWM",
                font = "Comforta Regular 28",
                halign = "left",
                valign = "center"
              },
              spacing = dpi(40),
              layout = wibox.layout.fixed.vertical
            },
            widget = wibox.container.margin,
            left = dpi(50),
          },
          widget = wibox.container.place,
          valign = "center"
        },
        widget = wibox.container.constraint,
        width = dpi((capi.screen.primary.geometry.width * 0.6) / 2),
        strategy = "exact",
      },
      { -- Right side with image
        {
          {
            widget = wibox.widget.imagebox,
            image = "/home/crylia/Bilder/57384097.jpg",
            resize = true,
            valign = "center",
            halign = "center"
          },
          widget = wibox.container.constraint,
          width = dpi((capi.screen.primary.geometry.width * 0.6) / 8),
          strategy = "exact",
        },
        forced_width = dpi((capi.screen.primary.geometry.width * 0.6) / 2),
        widget = wibox.container.place
      },
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.constraint,
    width = dpi(capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }
end

--- The second page, with a list of wallpapers to choose from
function setup:wallpaper_page()

  local path_promt = awidget.inputbox {
    hint_text = "Path to image...",
    halign = "left",
    valign = "center",
    font = "JetBrainsMono Regular 12",
  }

  local widget = wibox.widget {
    {
      {
        { -- Image
          {
            widget = wibox.widget.imagebox,
            resize = true,
            image = assets_dir .. "space.jpg",
            valign = "center",
            halign = "center",
            clip_shape = Theme_config.setup.wallpaper.clip_shape,
            id = "wallpaper"
          },
          widget = wibox.container.constraint,
          width = dpi(600),
          height = dpi(600 * 9 / 16),
          strategy = "exact",
        },
        { -- Button
          {
            {
              {
                {
                  {
                    {
                      widget = wibox.widget.imagebox,
                      image = icon_dir .. "choose.svg",
                      valign = "center",
                      halign = "center",
                      resize = true
                    },
                    widget = wibox.container.constraint,
                    width = dpi(36),
                    height = dpi(36),
                    strategy = "exact"
                  },
                  widget = wibox.container.margin,
                  left = dpi(10),
                },
                {
                  widget = wibox.widget.textbox,
                  markup = "Choose Wallpaper",
                  halign = "center",
                  valign = "center"
                },
                spacing = dpi(20),
                layout = wibox.layout.fixed.horizontal
              },
              widget = wibox.container.background,
              bg = Theme_config.setup.wallpaper.button_bg,
              fg = Theme_config.setup.wallpaper.button_fg,
              shape = Theme_config.setup.wallpaper.button_shape,
              id = "choose_image"
            },
            widget = wibox.container.constraint,
            width = dpi(300),
            height = dpi(60),
            strategy = "exact"
          },
          valign = "center",
          halign = "center",
          widget = wibox.container.place
        },
        { -- Path
          {
            {
              nil,
              { -- Text
                {
                  path_promt,
                  widget = wibox.container.constraint,
                  width = dpi(600),
                  height = dpi(50),
                  strategy = "exact"
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
              },
              { -- Button
                {
                  widget = wibox.widget.imagebox,
                  image = icon_dir .. "close.svg",
                  rezise = true,
                  id = "close"
                },
                widget = wibox.container.background,
                bg = gcolor.transparent,
                fg = Theme_config.setup.wallpaper.close_fg,
              },
              layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.background,
            bg = Theme_config.setup.wallpaper.path_bg,
            fg = Theme_config.setup.wallpaper.path_fg,
            shape = Theme_config.setup.wallpaper.path_shape,
          },
          widget = wibox.container.constraint,
          width = dpi(600),
          height = dpi(50),
          strategy = "exact"
        },
        spacing = dpi(28),
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.place,
      halign = "center",
      valign = "center",
    },
    widget = wibox.container.constraint,
    width = (capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }

  --Wallpaper
  local wallpaper = widget:get_children_by_id("wallpaper")[1]

  --Choose Image button
  local choose_image_button = widget:get_children_by_id("choose_image")[1]

  --Close button
  local close_button = widget:get_children_by_id("close")[1]

  choose_image_button:buttons(gtable.join(
    abutton({}, 1, function()
      aspawn.easy_async_with_shell(
        "zenity --file-selection --title='Select an Image File' --file-filter='Image File | *.jpg *.png'",
        function(stdout)
          stdout = stdout:gsub("\n", "")
          if stdout ~= "" then
            wallpaper:set_image(stdout)
            path_promt:set_text(stdout)
            self.wallpaper = stdout
          end
        end)
    end)
  ))

  close_button:buttons(gtable.join(
    abutton({}, 1, function()
      path_promt:set_text("")
      wallpaper:set_image(nil)
    end)
  ))

  Hover_signal(choose_image_button)

  return widget
end

-- Get a list of widgets from a verbal list
local function get_widgets()
  local widgets = {}

  for _, widget in pairs(widget_list) do
    local tb = toggle_button {
      size = dpi(30),
      color = Theme_config.setup.bar.widget_toggle_color,
    }

    local w = wibox.widget {
      nil,
      {
        {
          {
            widget = wibox.widget.textbox,
            text = widget,
            halign = "left",
            valign = "center",
            font = User_config.font.specify .. " Regular, 10"
          },
          widget = wibox.container.margin,
          margins = dpi(5),
        },
        widget = wibox.widget.background,
        bg = Theme_config.setup.bar.widget_bg,
        fg = Theme_config.setup.bar.widget_fg,
        shape = Theme_config.setup.bar.widget_shape,
        border_color = Theme_config.setup.bar.widget_border_color,
        border_width = Theme_config.setup.bar.widget_border_width
      },
      {
        tb,
        widget = wibox.container.margin,
        left = dpi(10),
      },
      id = "toggle_button",
      layout = wibox.layout.align.horizontal
    }

    table.insert(widgets, w)
  end

  return widgets
end

--- The third page, to customize the bar
function setup:bar_page()
  local widget = wibox.widget {
    { -- Top bar
      {
        { -- Title
          {
            widget = wibox.widget.textbox,
            text = "Top Bar",
            halign = "center",
            valign = "center",
          },
          widget = wibox.container.margin,
          margins = dpi(10)
        },
        { -- Bar preview
          {
            {
              {
                {
                  widget = wibox.widget.checkbox,
                  checked = true,
                  id = "topbar_checkbox",
                  shape = Theme_config.setup.bar.shape,
                  color = Theme_config.setup.bar.color,
                  padding = Theme_config.setup.bar.padding,
                },
                widget = wibox.container.constraint,
                width = 30,
                height = 30,
                strategy = "exact"
              },
              widget = wibox.container.place,
              halign = "right",
              valign = "center"
            },
            {
              {
                widget = wibox.widget.imagebox,
                image = "/home/crylia/Downloads/2022-12-08_23-19.png", --icon_dir .. "topbar.svg",
                resize = true,
                clip_shape = Theme_config.setup.bar.bar_image_shape,
                halign = "center",
                valign = "center"
              },
              widget = wibox.container.constraint,
              width = dpi(capi.screen.primary.geometry.width * 0.6),
              strategy = "exact"
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal
          },
          widget = wibox.container.margin,
          left = dpi(70),
          right = dpi(70),
        },
        {
          {
            { -- Widget selector
              {
                {
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "Left Widgets",
                      halign = "center",
                      valign = "center",
                    },
                    {
                      layout = require("src.lib.overflow_widget.overflow").vertical,
                      spacing = dpi(10),
                      step = dpi(50),
                      scrollbar_width = 0,
                      id = "left_top_widget_selector",
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                  },
                  widget = wibox.container.margin,
                  margins = dpi(10),
                },
                widget = wibox.container.background,
                border_color = Theme_config.setup.bar.border_color,
                border_width = Theme_config.setup.bar.border_width,
                shape = Theme_config.setup.bar.bar_shape,
              },
              {
                {
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "Center Widgets",
                      halign = "center",
                      valign = "center",
                    },
                    {
                      layout = require("src.lib.overflow_widget.overflow").vertical,
                      spacing = dpi(10),
                      step = dpi(50),
                      scrollbar_width = 0,
                      id = "center_top_widget_selector",
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                  },
                  widget = wibox.container.margin,
                  margins = dpi(10),
                },
                widget = wibox.container.background,
                border_color = Theme_config.setup.bar.border_color,
                border_width = Theme_config.setup.bar.border_width,
                shape = Theme_config.setup.bar.bar_shape,
              },
              {
                {
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "Right Widgets",
                      halign = "center",
                      valign = "center",
                    },
                    {
                      layout = require("src.lib.overflow_widget.overflow").vertical,
                      spacing = dpi(10),
                      step = dpi(50),
                      scrollbar_width = 0,
                      id = "right_top_widget_selector",
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                  },
                  widget = wibox.container.margin,
                  margins = dpi(10),
                },
                widget = wibox.container.background,
                border_color = Theme_config.setup.bar.border_color,
                border_width = Theme_config.setup.bar.border_width,
                shape = Theme_config.setup.bar.bar_shape,
              },
              expand = "none",
              forced_width = dpi(capi.screen.primary.geometry.width * 0.6) * 0.4,
              layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.constraint,
            height = dpi(capi.screen.primary.geometry.width * 0.6 * 9 / 16) * 0.3,
            strategy = "exact",
          },
          widget = wibox.container.margin,
          left = dpi(140),
          right = dpi(140),
        },
        spacing = dpi(20),
        layout = wibox.layout.fixed.vertical
      },
      {
        widget = wibox.container.background,
        bg = gcolor.transparent,
        id = "top_overlay"
      },
      layout = wibox.layout.stack
    },
    {
      { -- Bottom bar
        { -- Widget selector
          {
            {
              {
                {
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "Left Widgets",
                      halign = "center",
                      valign = "center",
                    },
                    {
                      widget = require("src.lib.overflow_widget.overflow").vertical,
                      spacing = dpi(10),
                      step = dpi(50),
                      scrollbar_width = 0,
                      id = "left_bottom_widget_selector",
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                  },
                  widget = wibox.container.margin,
                  margins = dpi(10),
                },
                widget = wibox.container.background,
                border_color = Theme_config.setup.bar.border_color,
                border_width = Theme_config.setup.bar.border_width,
                shape = Theme_config.setup.bar.bar_shape,
              },
              {
                {
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "Center Widgets",
                      halign = "center",
                      valign = "center",
                    },
                    {
                      widget = require("src.lib.overflow_widget.overflow").vertical,
                      spacing = dpi(10),
                      step = dpi(50),
                      scrollbar_width = 0,
                      id = "center_bottom_widget_selector",
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                  },
                  widget = wibox.container.margin,
                  margins = dpi(10),
                },
                widget = wibox.container.background,
                border_color = Theme_config.setup.bar.border_color,
                border_width = Theme_config.setup.bar.border_width,
                shape = Theme_config.setup.bar.bar_shape,
              },
              {
                {
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "Right Widgets",
                      halign = "center",
                      valign = "center",
                    },
                    {
                      widget = require("src.lib.overflow_widget.overflow").vertical,
                      spacing = dpi(10),
                      step = dpi(50),
                      scrollbar_width = 0,
                      id = "right_bottom_widget_selector",
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical,
                  },
                  widget = wibox.container.margin,
                  margins = dpi(10),
                },
                widget = wibox.container.background,
                border_color = Theme_config.setup.bar.border_color,
                border_width = Theme_config.setup.bar.border_width,
                shape = Theme_config.setup.bar.bar_shape,
              },
              expand = "none",
              forced_width = dpi(capi.screen.primary.geometry.width * 0.6) * 0.4,
              layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.constraint,
            height = dpi(capi.screen.primary.geometry.width * 0.6 * 9 / 16) * 0.3,
            strategy = "exact",
          },
          widget = wibox.container.margin,
          left = dpi(140),
          right = dpi(140),
        },
        { -- Bar preview
          {
            {
              {
                {
                  widget = wibox.widget.checkbox,
                  checked = false,
                  id = "bottombar_checkbox",
                  shape = Theme_config.setup.bar.shape,
                  color = Theme_config.setup.bar.color,
                  padding = Theme_config.setup.bar.padding,
                },
                widget = wibox.container.constraint,
                width = 30,
                height = 30,
                strategy = "exact"
              },
              widget = wibox.container.place,
              halign = "right",
              valign = "center"
            },
            {
              {
                widget = wibox.widget.imagebox,
                image = "/home/crylia/Downloads/2022-12-08_23-19.png", --icon_dir .. "topbar.svg",
                resize = true,
                clip_shape = Theme_config.setup.bar.bar_image_shape,
                halign = "center",
                valign = "center"
              },
              widget = wibox.container.constraint,
              width = dpi(capi.screen.primary.geometry.width * 0.6),
              strategy = "exact"
            },
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal
          },
          widget = wibox.container.margin,
          left = dpi(70),
          right = dpi(70),
        },
        { -- Title
          {
            widget = wibox.widget.textbox,
            text = "Bottom Bar",
            halign = "center",
            valign = "center",
          },
          widget = wibox.container.margin,
          margins = dpi(10)
        },
        spacing = dpi(20),
        layout = wibox.layout.fixed.vertical
      },
      {
        widget = wibox.container.background,
        bg = gcolor("#212121BB"),
        id = "bottom_overlay"
      },
      layout = wibox.layout.stack
    },
    spacing_widget = wibox.widget.separator,
    spacing = dpi(5),
    forced_width = dpi(capi.screen.primary.geometry.width * 0.6),
    layout = wibox.layout.flex.vertical
  }

  local top_checkbox, bottom_checkbox = widget:get_children_by_id("topbar_checkbox")[1],
      widget:get_children_by_id("bottombar_checkbox")[1]

  local top_overlay, bottom_overlay = widget:get_children_by_id("top_overlay")[1],
      widget:get_children_by_id("bottom_overlay")[1]

  top_checkbox:buttons(gtable.join(
    abutton({}, 1, nil, function()
      top_checkbox.checked = not top_checkbox.checked
      bottom_checkbox.checked = not top_checkbox.checked
      if top_checkbox.checked then
        top_overlay.bg = gcolor.transparent
        bottom_overlay.bg = gcolor("#212121BB")
      else
        top_overlay.bg = gcolor("#212121BB")
        bottom_overlay.bg = gcolor.transparent
      end
    end
    )
  ))

  bottom_checkbox:buttons(gtable.join(
    abutton({}, 1, nil, function()
      bottom_checkbox.checked = not bottom_checkbox.checked
      top_checkbox.checked = not bottom_checkbox.checked
      if bottom_checkbox.checked then
        top_overlay.bg = gcolor("#212121BB")
        bottom_overlay.bg = gcolor.transparent
      else
        top_overlay.bg = gcolor.transparent
        bottom_overlay.bg = gcolor("#212121BB")
      end
    end
    )
  ))

  widget:get_children_by_id("left_top_widget_selector")[1].children = get_widgets()
  widget:get_children_by_id("center_top_widget_selector")[1].children = get_widgets()
  widget:get_children_by_id("right_top_widget_selector")[1].children = get_widgets()
  widget:get_children_by_id("left_bottom_widget_selector")[1].children = get_widgets()
  widget:get_children_by_id("center_bottom_widget_selector")[1].children = get_widgets()
  widget:get_children_by_id("right_bottom_widget_selector")[1].children = get_widgets()


  return widget
end

local function get_status_bars()
  local widgets = wibox.widget {
    layout = wibox.layout.flex.horizontal,
    spacing = dpi(100),
    { layout = wibox.layout.fixed.vertical, id = "left", spacing = dpi(10) },
    { layout = wibox.layout.fixed.vertical, id = "right", spacing = dpi(10) }
  }

  for i, widget in pairs(statusbar_list) do
    local tb = toggle_button {
      size = dpi(30),
      color = Theme_config.setup.bar.widget_toggle_color,
    }

    local w = wibox.widget {
      nil,
      {
        {
          widget = wibox.widget.textbox,
          text = widget,
          halign = "left",
          valign = "center",
          font = User_config.font.specify .. " Regular, 14"
        },
        widget = wibox.container.margin,
        margins = dpi(5),
      },
      {
        tb,
        widget = wibox.container.margin,
        left = dpi(10),
      },
      id = "toggle_button",
      layout = wibox.layout.align.horizontal
    }
    if i <= math.ceil(#statusbar_list / 2) then
      widgets:get_children_by_id("left")[1]:add(w)
    else
      widgets:get_children_by_id("right")[1]:add(w)
    end
  end

  return widgets
end

--- The fourth page, to customize the notification center
function setup:notification_page()
  local secrets = {
    api_key = awidget.inputbox {
      hint_text = "API Key...",
      valign = "center",
      halign = "left"
    },
    city_id = awidget.inputbox {
      hint_text = "City ID...",
      valign = "center",
      halign = "left"
    }
  }

  local widget = wibox.widget {
    {
      {
        {
          widget = wibox.widget.textbox,
          text = "Notification Center Setup",
          font = User_config.font.specify .. " Regular, 24",
          halign = "center",
          valign = "center",
        },
        widget = wibox.container.margin,
        margins = dpi(10)
      },
      {
        { -- Status bars
          { -- Title
            {
              widget = wibox.widget.textbox,
              text = "Status bars",
              font = User_config.font.specify .. " Regular, 16",
              halign = "center",
            },
            widget = wibox.container.margin,
            top = dpi(5),
            bottom = dpi(100)
          },
          {
            { -- Icon
              widget = wibox.widget.imagebox,
              image = icon_dir .. "status_bars.png",
              resize = false,
              forced_width = dpi(250),
              halign = "center",
              id = "sb_icon"
            },
            {
              get_status_bars(),
              widget = wibox.container.margin,
              left = dpi(100),
              right = dpi(100)
            },
            expand = "none",
            layout = wibox.layout.flex.vertical
          },
          nil,
          layout = wibox.layout.align.vertical
        },
        { -- OpenWeatherMap API
          { -- Title
            {
              widget = wibox.widget.textbox,
              text = "OpenWeatherMap API",
              font = User_config.font.specify .. " Regular, 16",
              halign = "center",
            },
            widget = wibox.container.margin,
            top = dpi(5),
          },
          {
            {
              { -- Icon
                {
                  widget = wibox.widget.imagebox,
                  image = icon_dir .. "openweathermap.png",
                  resize = true,
                  halign = "center",
                  id = "opw_icon"
                },
                widget = wibox.container.constraint,
                width = dpi(250),
                strategy = "exact"
              },
              { -- Secrets
                { -- API Key
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "API Key",
                      font = User_config.font.specify .. " Regular, 16",
                      halign = "center",
                      valign = "center",
                    },
                    widget = wibox.container.margin,
                    right = dpi(20),
                  },
                  {
                    {
                      secrets.api_key,
                      widget = wibox.container.margin,
                      left = dpi(10)
                    },
                    id = "api_key_input",
                    forced_height = dpi(50),
                    forced_width = dpi(400),
                    widget = wibox.container.background,
                    border_color = Theme_config.setup.notification.border_color,
                    border_width = Theme_config.setup.notification.border_width,
                    shape = Theme_config.setup.notification.shape,
                  },
                  layout = wibox.layout.align.horizontal
                },
                { -- City ID
                  {
                    {
                      widget = wibox.widget.textbox,
                      text = "City ID",
                      font = User_config.font.specify .. " Regular, 16",
                      halign = "center",
                      valign = "center",
                    },
                    widget = wibox.container.margin,
                    right = dpi(20),
                  },
                  {
                    {
                      secrets.city_id,
                      widget = wibox.container.margin,
                      left = dpi(10),
                    },
                    id = "city_id_input",
                    forced_height = dpi(50),
                    forced_width = dpi(400),
                    widget = wibox.container.background,
                    border_color = Theme_config.setup.notification.border_color,
                    border_width = Theme_config.setup.notification.border_width,
                    shape = Theme_config.setup.notification.shape,
                  },
                  layout = wibox.layout.align.horizontal
                },
                spacing = dpi(40),
                layout = wibox.layout.flex.vertical,
              },
              { -- Unit selection
                { -- Celsius
                  {
                    {
                      {
                        widget = wibox.widget.checkbox,
                        checked = true,
                        color = Theme_config.setup.notification.checkbox_color,
                        paddings = Theme_config.setup.notification.checkbox_paddings,
                        shape = Theme_config.setup.notification.checkbox_shape,
                        id = "celsius_selector",
                      },
                      widget = wibox.container.constraint,
                      width = dpi(24),
                      height = dpi(24),
                    },
                    widget = wibox.container.place,
                    halign = "center",
                    valign = "center",
                  },
                  {
                    widget = wibox.widget.textbox,
                    text = "Celsius °C",
                    font = User_config.font.specify .. " Regular, 14",
                    halign = "center",
                    valign = "center",
                  },
                  spacing = dpi(10),
                  layout = wibox.layout.fixed.vertical
                },
                { -- Fahrenheit
                  {
                    {
                      {
                        widget = wibox.widget.checkbox,
                        checked = false,
                        color = Theme_config.setup.notification.checkbox_color,
                        paddings = Theme_config.setup.notification.checkbox_paddings,
                        shape = Theme_config.setup.notification.checkbox_shape,
                        id = "Fahrenheit_selector",
                      },
                      widget = wibox.container.constraint,
                      width = dpi(24),
                      height = dpi(24)
                    },
                    widget = wibox.container.place,
                    halign = "center",
                    valign = "center",
                  },
                  {
                    widget = wibox.widget.textbox,
                    text = "Fahrenheit °F",
                    font = User_config.font.specify .. " Regular, 14",
                    halign = "center",
                    valign = "center",
                  },
                  spacing = dpi(10),
                  layout = wibox.layout.fixed.vertical
                },
                layout = wibox.layout.flex.horizontal
              },
              spacing = dpi(100),
              layout = wibox.layout.fixed.vertical,
            },
            widget = wibox.container.place,
            halign = "center",
            valign = "center"
          },
          nil,
          layout = wibox.layout.align.vertical,
        },
        spacing_widget = wibox.widget.separator {
          color = Theme_config.setup.notification.separator_color,
        },
        spacing = dpi(5),
        layout = wibox.layout.flex.horizontal,
      },
      nil,
      layout = wibox.layout.align.vertical
    },
    widget = wibox.container.constraint,
    width = dpi(capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }

  -- Toggle both checkboxes so they act as radio buttons
  local celsius_selector = widget:get_children_by_id("celsius_selector")[1]
  local fahrenheit_selector = widget:get_children_by_id("Fahrenheit_selector")[1]
  celsius_selector:buttons(gtable.join(
    abutton({}, 1, nil, function()
      celsius_selector.checked = true
      fahrenheit_selector.checked = false
    end)
  ))
  fahrenheit_selector:buttons(gtable.join(
    abutton({}, 1, nil, function()
      celsius_selector.checked = false
      fahrenheit_selector.checked = true
    end)
  ))

  local opw_icon = widget:get_children_by_id("opw_icon")[1]
  opw_icon:buttons(gtable.join(
    abutton({}, 1, nil, function()
      aspawn.with_shell("xdg-open https://openweathermap.org/")
    end)
  ))

  local api_key_input = widget:get_children_by_id("api_key_input")[1]
  local city_id_input = widget:get_children_by_id("city_id_input")[1]
  api_key_input:buttons(gtable.join(
    abutton({}, 1, nil, function()
      secrets.api_key:focus()
    end)
  ))

  city_id_input:buttons(gtable.join(
    abutton({}, 1, nil, function()
      secrets.city_id:focus()
    end)
  ))

  --#region Mouse changes
  local old_mouse, old_wibox
  local function mouse_enter(icon)
    local wb = mouse.current_wibox
    if wb then
      old_mouse, old_wibox = wb.cursor, wb
      wb.cursor = icon
    end
  end

  local function mouse_leave()
    if old_wibox then
      old_wibox.cursor = old_mouse
      old_wibox = nil
    end
  end

  api_key_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  api_key_input:connect_signal("mouse::leave", mouse_leave)
  city_id_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  city_id_input:connect_signal("mouse::leave", mouse_leave)
  opw_icon:connect_signal("mouse::enter", function() mouse_enter("hand1") end)
  opw_icon:connect_signal("mouse::leave", mouse_leave)
  celsius_selector:connect_signal("mouse::enter", function() mouse_enter("hand1") end)
  celsius_selector:connect_signal("mouse::leave", mouse_leave)
  fahrenheit_selector:connect_signal("mouse::enter", function() mouse_enter("hand1") end)
  fahrenheit_selector:connect_signal("mouse::leave", mouse_leave)

  --#endregion

  return widget
end

--- The fifth page, to customize the default programs
function setup:programs_page()
  local applications = {
    power_manager = awidget.inputbox { hint_text = "e.g. xfce4-power-manager-settings" },
    web_browser = awidget.inputbox { hint_text = "e.g. firefox" },
    terminal = awidget.inputbox { hint_text = "e.g. kitty" },
    text_editor = awidget.inputbox { hint_text = "e.g. code" },
    music_player = awidget.inputbox { hint_text = "e.g. flatpak run com.spotify.Client" },
    gtk_settings = awidget.inputbox { hint_text = "e.g. lxappearance" },
    file_manager = awidget.inputbox { hint_text = "e.g. nautilus" },
    screen_manager = awidget.inputbox { hint_text = "e.g. arandr" }
  }

  local widget = wibox.widget {
    {
      { -- Title
        {
          widget = wibox.widget.textbox,
          text = "Default Applications",
          font = User_config.font.specify .. " Regular, 24",
          halign = "center",
          valign = "center",
        },
        widget = wibox.container.margin,
        margins = dpi(10)
      },
      {
        { -- Left side Applications
          {
            { -- power_manager
              {
                {
                  widget = wibox.widget.textbox,
                  text = "Power Manager",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.power_manager,
                  widget = wibox.container.margin,
                  left = dpi(10)
                },
                id = "power_manager_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            { -- web_browser
              {
                {
                  widget = wibox.widget.textbox,
                  text = "Web Browser",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.web_browser,
                  widget = wibox.container.margin,
                  left = dpi(10),
                },
                id = "web_browser_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            { -- terminal
              {
                {
                  widget = wibox.widget.textbox,
                  text = "Terminal",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.terminal,
                  widget = wibox.container.margin,
                  left = dpi(10),
                },
                id = "terminal_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            { -- text_editor
              {
                {
                  widget = wibox.widget.textbox,
                  text = "Text Editor",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.text_editor,
                  widget = wibox.container.margin,
                  left = dpi(10),
                },
                id = "text_editor_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            spacing = dpi(40),
            layout = wibox.layout.fixed.vertical,
          },
          widget = wibox.container.place,
          valign = "center",
          halign = "center",
        },
        { -- Right side Applications
          {
            { -- music_player
              {
                {
                  widget = wibox.widget.textbox,
                  text = "Music Player",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.music_player,
                  widget = wibox.container.margin,
                  left = dpi(10)
                },
                id = "music_player_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            { -- gtk settings
              {
                {
                  widget = wibox.widget.textbox,
                  text = "GTK Settings",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.gtk_settings,
                  widget = wibox.container.margin,
                  left = dpi(10),
                },
                id = "gtk_settings_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            { -- file manager
              {
                {
                  widget = wibox.widget.textbox,
                  text = "File Manager",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.file_manager,
                  widget = wibox.container.margin,
                  left = dpi(10),
                },
                id = "file_manager_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            { -- Screen Manager
              {
                {
                  widget = wibox.widget.textbox,
                  text = "Screen Manager",
                  font = User_config.font.specify .. " Regular, 14",
                  halign = "center",
                  valign = "center",
                },
                widget = wibox.container.margin,
                right = dpi(20),
              },
              nil,
              {
                {
                  applications.screen_manager,
                  widget = wibox.container.margin,
                  left = dpi(10),
                },
                id = "screen_manager_input",
                forced_height = dpi(50),
                forced_width = dpi(350),
                widget = wibox.container.background,
                border_color = Theme_config.setup.notification.border_color,
                border_width = Theme_config.setup.notification.border_width,
                shape = Theme_config.setup.notification.shape,
              },
              expand = "none",
              layout = wibox.layout.align.horizontal
            },
            spacing = dpi(40),
            layout = wibox.layout.fixed.vertical,
          },
          widget = wibox.container.place,
          valign = "center",
          halign = "center",
        },
        layout = wibox.layout.flex.horizontal
      },
      nil,
      layout = wibox.layout.align.vertical
    },
    widget = wibox.container.constraint,
    width = dpi(capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }

  local power_manager_input = widget:get_children_by_id("power_manager_input")[1]
  local web_browser_input = widget:get_children_by_id("web_browser_input")[1]
  local terminal_input = widget:get_children_by_id("terminal_input")[1]
  local text_editor_input = widget:get_children_by_id("text_editor_input")[1]
  local music_player_input = widget:get_children_by_id("music_player_input")[1]
  local gtk_settings_input = widget:get_children_by_id("gtk_settings_input")[1]
  local file_manager_input = widget:get_children_by_id("file_manager_input")[1]
  local screen_manager_input = widget:get_children_by_id("screen_manager_input")[1]

  applications.power_manager:buttons(gtable.join {
    abutton({}, 1, function()
      applications.power_manager:focus()
    end)
  })
  applications.web_browser:buttons(gtable.join {
    abutton({}, 1, function()
      applications.web_browser:focus()
    end)
  })
  applications.terminal:buttons(gtable.join {
    abutton({}, 1, function()
      applications.terminal:focus()
    end)
  })
  applications.text_editor:buttons(gtable.join {
    abutton({}, 1, function()
      applications.text_editor:focus()
    end)
  })
  applications.music_player:buttons(gtable.join {
    abutton({}, 1, function()
      applications.music_player:focus()
    end)
  })
  applications.gtk_settings:buttons(gtable.join {
    abutton({}, 1, function()
      applications.gtk_settings:focus()
    end)
  })
  applications.file_manager:buttons(gtable.join {
    abutton({}, 1, function()
      applications.file_manager:focus()
    end)
  })
  applications.screen_manager:buttons(gtable.join {
    abutton({}, 1, function()
      applications.screen_manager:focus()
    end)
  })

  --#region Mouse changes
  local old_mouse, old_wibox
  local function mouse_enter(icon)
    local wb = mouse.current_wibox
    if wb then
      old_mouse, old_wibox = wb.cursor, wb
      wb.cursor = icon
    end
  end

  local function mouse_leave()
    if old_wibox then
      old_wibox.cursor = old_mouse
      old_wibox = nil
    end
  end

  power_manager_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  power_manager_input:connect_signal("mouse::leave", mouse_leave)
  web_browser_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  web_browser_input:connect_signal("mouse::leave", mouse_leave)
  terminal_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  terminal_input:connect_signal("mouse::leave", mouse_leave)
  text_editor_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  text_editor_input:connect_signal("mouse::leave", mouse_leave)
  music_player_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  music_player_input:connect_signal("mouse::leave", mouse_leave)
  gtk_settings_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  gtk_settings_input:connect_signal("mouse::leave", mouse_leave)
  file_manager_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  file_manager_input:connect_signal("mouse::leave", mouse_leave)
  screen_manager_input:connect_signal("mouse::enter", function() mouse_enter("xterm") end)
  screen_manager_input:connect_signal("mouse::leave", mouse_leave)

  --#endregion

  return widget
end

local function get_layouts()
  local layouts = {
    ["cornerne"]    = Theme.layout_cornerne,
    ["cornernw"]    = Theme.layout_cornernw,
    ["cornerse"]    = Theme.layout_cornerse,
    ["cornersw"]    = Theme.layout_cornersw,
    ["dwindle"]     = Theme.layout_dwindle,
    ["fairh"]       = Theme.layout_fairh,
    ["fairv"]       = Theme.layout_fairv,
    ["floating"]    = Theme.layout_floating,
    ["fullscreen"]  = Theme.layout_fullscreen,
    ["magnifier"]   = Theme.layout_magnifier,
    ["max"]         = Theme.layout_max,
    ["spiral"]      = Theme.layout_spiral,
    ["tile bottom"] = Theme.layout_cornerse,
    ["tile left"]   = Theme.layout_cornernw,
    ["tile top"]    = Theme.layout_cornersw,
    ["tile"]        = Theme.layout_cornerne,
  }

  local list = {}

  for layout, icon in pairs(layouts) do
    local w = wibox.widget {
      {
        {
          {
            {
              {
                image = icon,
                resize = true,
                widget = wibox.widget.imagebox,
              },
              widget = wibox.container.constraint,
              width = dpi(64),
              height = dpi(64)
            },
            margins = dpi(10),
            widget = wibox.container.margin
          },
          bg = Theme_config.setup.layout.bg,
          shape = Theme_config.setup.layout.shape,
          widget = wibox.container.background
        },
        margins = dpi(10),
        widget = wibox.container.margin
      },
      widget = wibox.container.background,
      border_color = Theme_config.setup.layout.border_color,
      border_width = Theme_config.setup.layout.border_width,
      shape = Theme_config.setup.layout.shape,
      selected = false
    }

    w:buttons(gtable.join {
      abutton({}, 1, function()
        if w.selected then
          w.border_color = Theme_config.setup.layout.border_color
          w.selected = false
        else
          w.border_color = Theme_config.setup.layout.border_color_selected
          w.selected = true
        end
      end)
    })

    atooltip {
      objects = { w },
      mode = "inside",
      align = "bottom",
      timeout = 0.5,
      text = layout,
      preferred_positions = { "right", "left", "top", "bottom" },
      margin_leftright = dpi(8),
      margin_topbottom = dpi(8),
    }

    table.insert(list, w)
  end

  return list
end

--- The sixth page, to choose the layouts
function setup:layouts_page()
  local layouts = get_layouts()

  local widget = wibox.widget {
    {
      { -- Title
        {
          widget = wibox.widget.textbox,
          text = "Layouts",
          font = User_config.font.specify .. " Regular, 24",
          halign = "center",
          valign = "center",
        },
        widget = wibox.container.margin,
        margins = dpi(10)
      },
      {
        {
          spacing = dpi(20),
          forced_num_cols = 4,
          forced_num_rows = 4,
          horizontal_homogeneous = true,
          vertical_homogeneous = true,
          layout = wibox.layout.grid,
          id = "layout_grid"
        },
        widget = wibox.container.place,
        halign = "center",
        valign = "center"
      },
      nil,
      layout = wibox.layout.align.vertical
    },
    widget = wibox.container.constraint,
    width = dpi(capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }

  local layout_grid = widget:get_children_by_id("layout_grid")[1]

  for _, layout in ipairs(layouts) do
    layout_grid:add(layout)
  end

  return widget
end

--- The seventh page, to customize the titlebar
function setup:titlebar_page()
  local widget = wibox.widget {
    widget = wibox.container.constraint,
    width = dpi(capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }

  return widget
end

--- The eighth page, to chose the font and icon theme
function setup:font_page()
  local widget = wibox.widget {
    widget = wibox.container.constraint,
    width = dpi(capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }

  return widget
end

--- The ninth page, finish page, restart awesome
function setup:final_page()
  local widget = wibox.widget {
    widget = wibox.container.constraint,
    width = dpi(capi.screen.primary.geometry.width * 0.6),
    strategy = "exact",
  }

  return widget
end

--- Show the next page
function setup:next()
  self.main_content:scroll(capi.screen.primary.geometry.width * 0.6)
end

--- Show the previous page
function setup:prev()
  self.main_content:scroll(-capi.screen.primary.geometry.width * 0.6)
end

function setup.new(args)
  args = args or {}

  -- Always display on the main screen
  local screen = capi.screen.primary

  local self = apopup {
    widget = {
      {
        nil,
        {
          { -- Main content
            widget = require("src.lib.overflow_widget.overflow").horizontal,
            scrollbar_width = 0,
            step = 1.08,
            id = "main_content"
          },
          { -- Left button
            {
              {
                {
                  widget = wibox.widget.imagebox,
                  image = icon_dir .. "left.svg",
                  rezise = true
                },
                widget = wibox.container.background,
                id = "page_left",
                bg = Theme_config.setup.bg .. "88",
              },
              widget = wibox.container.constraint,
              width = dpi(64),
              height = dpi(64),
              strategy = "exact"
            },
            valign = "center",
            halign = "left",
            widget = wibox.container.place
          },
          { -- Right button
            {
              {
                {
                  widget = wibox.widget.imagebox,
                  image = icon_dir .. "right.svg",
                  rezise = true
                },
                widget = wibox.container.background,
                id = "page_right",
                bg = Theme_config.setup.bg .. "88",
              },
              widget = wibox.container.constraint,
              width = dpi(64),
              height = dpi(64),
              strategy = "exact"
            },
            valign = "center",
            halign = "right",
            widget = wibox.container.place
          },

          layout = wibox.layout.stack
        },
        {
          { -- Current Page
            widget = wibox.widget.textbox,
            halign = "center",
            valign = "center",
            id = "current_page"
          },
          widget = wibox.container.margin,
          margins = dpi(10),
        },
        layout = wibox.layout.align.vertical
      },
      widget = wibox.container.constraint,
      width = dpi(screen.geometry.width * 0.6),
      height = dpi(screen.geometry.width * 0.6 * 9 / 16),
      strategy = "exact"
    },
    screen = screen,
    bg = Theme_config.setup.bg,
    border_color = Theme_config.setup.border_color,
    border_width = Theme_config.setup.border_width,
    placement = aplacement.centered,
    ontop = false, -- !CHANGE THIS TO TRUE WHEN DONE TESTING!
    visible = true,
  }

  gtable.crush(self, setup, true)

  self.main_content = self.widget:get_children_by_id("main_content")[1]

  self.main_content.children = create_pages()

  self.page = 1

  -- Current page
  local current_page = self.widget:get_children_by_id("current_page")[1]

  current_page:set_text(self.page .. " / " .. #self.main_content.children)

  -- Left button
  local page_left = self.widget:get_children_by_id("page_left")[1]
  page_left:buttons(gtable.join(
    abutton({}, 1, function()
      if self.page == 1 then return end
      self:prev()
      self.page = self.page - 1
      current_page:set_text(self.page .. " / " .. #self.main_content.children)
    end)
  ))

  -- Right button
  local page_right = self.widget:get_children_by_id("page_right")[1]
  page_right:buttons(gtable.join(
    abutton({}, 1, function()
      if self.page == #self.main_content.children then return end
      self:next()
      self.page = self.page + 1
      current_page:set_text(self.page .. " / " .. #self.main_content.children)
    end)
  ))

end

function setup.mt:__call(...)
  return setup.new(...)
end

return setmetatable(setup, setup.mt)
