local app_dir = '/usr/local/share/tarantool/test.lua'

package.path = app_dir .. '/?.lua;' .. package.path

local httpd  = require 'http.server'
local config = require 'config'

box.cfg{}

local space  = config.space
local params = config.params

if not box.space[space] then
    local schema = box.schema.space.create(space)
    schema:format(config.format)
    schema:create_index('primary', { type = 'hash', parts = { '_key' } })
end

params.app_dir = app_dir

local srv = httpd.new( config.host, config.port, params )
for _, descr in pairs(config.routes) do
    srv:route( descr, 'main#' .. descr.name )
end

-- Start Server

srv:start()
