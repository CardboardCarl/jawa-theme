-------------------------------------------------------------------------------------------------
-- This class contains rules for float exceptions or special themeing for certain applications --
-------------------------------------------------------------------------------------------------

-- Awesome Libs
local aclient = require('awful.client')
local aplacement = require('awful.placement')
local ascreen = require('awful.screen')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi
local ruled = require('ruled')

local config = require('src.tools.config')

awesome.register_xproperty('_NET_WM_BYPASS_COMPOSITOR', 'boolean')

ruled.client.connect_signal('request::rules', function()
  ruled.client.append_rule {
    rule = {},
    properties = {
      border_width = dpi(2),
      border_color = beautiful.colorscheme.border_color,
      maximized = false,
      maximized_horizontal = false,
      maximized_vertical = false,
      focus = aclient.focus.filter,
      raise = true,
      keys = require('src.bindings.client_keys'),
      buttons = require('src.bindings.client_buttons'),
      screen = ascreen.preferred,
      placement = aplacement.under_mouse + aplacement.no_overlap + aplacement.no_offscreen + aplacement.centered,
    },
  }

  ruled.client.append_rule {
    rule_any = {
      type = {
        'normal',
        'dialog',
      },
    },
    properties = {
      titlebars_enabled = true,
    },
  }

  ruled.client.append_rule {
    rule_any = {
      class = {
        'proton-bridge',
        '1password',
        'protonvpn',
        'Steam',
      },
    },
    properties = {
      minimized = true,
    },
  }
  ruled.client.append_rule {
    rule_any = {
      class = {
        'discord',
        'spotify',
      },
    },
    properties = {
      tag = '1',
      screen = 2,
    },
  }

  ruled.client.append_rule {
    rule_any = {
      class = {
        'steam_app_990080',
      },
    },
    callback = function(c)
      c:set_xproperty('_NET_WM_BYPASS_COMPOSITOR', true)
      c:connect_signal('focus', function()
        c:set_xproperty('_NET_WM_BYPASS_COMPOSITOR', true)
      end)
      c:connect_signal('raised', function()
        c:set_xproperty('_NET_WM_BYPASS_COMPOSITOR', true)
      end)
    end,
  }

end)

do
  local data = config.read_json('/home/crylia/.config/awesome/src/config/floating.json')
  for _, c in ipairs(data) do
    ruled.client.append_rule {
      rule = { class = c.WM_CLASS, instance = c.WM_INSTANCE },
      properties = {
        floating = true,
      },
    }
  end
end
