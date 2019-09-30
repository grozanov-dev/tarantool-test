local app_dir = '/usr/local/share/tarantool/test.lua'

package.path = app_dir .. '/?.lua;' .. package.path

local httpd   = require 'http.server'
local config  = require 'config'

box.cfg{}

local spaces = config.spaces
local params = config.params

for _, space in pairs(spaces) do
    if not box.space[space.name] then
        local schema = box.schema.space.create(space.name)
        schema:format(space.format)
        schema:create_index('primary', { type = 'hash', parts = { space.key_field } })
    end
end

params.app_dir = app_dir

local srv = httpd.new( config.host, config.port, params )

for _, descr in pairs(config.routes) do
    srv:route( descr, 'main#' .. descr.name )
end

-- Start Expiration Arbiter

local arbiter = require 'arbiter'

-- Start Server

srv:start()
