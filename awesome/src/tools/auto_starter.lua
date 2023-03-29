local Gio = require('lgi').Gio
local aspawn = require('awful.spawn')
local gfilesystem = require('gears.filesystem')

local capi = {
  awesome = awesome,
}

local function is_restart()
  capi.awesome.register_xproperty('is_restart', 'boolean')
  local restart_detected = capi.awesome.get_xproperty('is_restart') ~= nil
  capi.awesome.set_xproperty('is_restart', true)

  return restart_detected
end

return function(table)

  if is_restart() then return end

  for _, t in ipairs(table) do
    aspawn(t);
  end
  local path = gfilesystem.get_xdg_config_home() .. 'autostart/'
  local handler = io.popen('ls ' .. path)
  if not handler then return end

  for file in handler:lines() do
    local app = Gio.DesktopAppInfo.new_from_filename(path .. file)
    if app then
      Gio.AppInfo.launch_uris_async(Gio.AppInfo.create_from_commandline(Gio.DesktopAppInfo.get_string(app, 'Exec'), nil, 0))
    end
  end
end
