-- expiraton arbiter

local config = require 'config'
local log    = require 'log'
local fiber  = require 'fiber'

local aspace = config.spaces.arbiter

local function _expired(tuple)
    log.info(tuple[3])
    local interval = aspace.sleep + aspace.ttl
    if ( fiber.time() - tuple[3] ) > interval then return true end
    return false
end

local function _delete(tuple)
    box.space[aspace.name]:delete { tuple[1] }
end

local function get_tuples(offset)
    return box.space[aspace.name]:select(
        nil,
        {
            iterator = 'ALL',
            offset = offset,
            limit = aspace.tuples_per_iteration
        }
    )
end

local function arbiter()
    while true do
        local offset = 0
        fiber.sleep(aspace.sleep)
        local tuples = get_tuples(offset)
        while #tuples > 0 do
            for _, tuple in ipairs(tuples) do
                if _expired(tuple) then
                    _delete(tuple)
                end
            end
            offset = offset + #tuples
            tuples = get_tuples(offset)
        end
    end
end

return fiber.create(arbiter)