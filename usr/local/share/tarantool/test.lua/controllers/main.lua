-- controller.main

local json   = require 'json'
local config = require 'config'
local fiber  = require 'fiber'
local log    = require 'log'

local status  = config.status
local dspace  = config.spaces.data
local aspace  = config.spaces.arbiter
local space   = box.space[dspace.name]
local arbiter = box.space[aspace.name]

local function create_response(status, body)
    if body then body = json.encode(body) end
    return {
        ['status']  = status,
        ['headers'] = { ['content-type'] = 'application/json; charset=utf8' },
        ['body']    = body
    }
end

-- Хуки не использовал специально
-- req сюда передаётся на будущее, если возникнет желание сделать раздельный fcap по IPшникам
local function frequency_cap(req)
    local aobj = arbiter:get { aspace.key }
    if aobj then
        arbiter:update( { aobj[1] }, { { '+', 2, 1 } } )
        if aobj[2] > aspace.max_requests_per_ttl then return true end
    else
        arbiter:insert { aspace.key, 0, fiber.time() }
    end
    return false
end

local function parse_request(req)
    return req:json()
end

function _get(key)
    local data = space:get { key }
    if data then return data[dspace.data_field] end
end

function _set(key, val)
    space:insert { key, val }
end

function _put(key, val)
    space:update( { key }, { { '=', dspace.data_field, val } } )
end

function _del(key)
    space:delete { key }
end

return {
    post = function(self)
            if frequency_cap(self) then return create_response(status.TOO_MANY_REQUESTS) end
            local data = parse_request(self)
            if data then
                if _get(data.key) then
                    return create_response(status.CONFLICT)
                else
                    _set(data.key, data.value)
                    return create_response(status.OK)
                end
            end
            return create_response(status.BAD_REQUEST)
        end,

    get = function(self)
            if frequency_cap(self) then return create_response(status.TOO_MANY_REQUESTS) end
            local id = self:stash('id')
            local data = _get(id)
            if data then
                return create_response(status.OK, data)
            end
            return create_response(status.NO_CONTENT)
        end,

    put = function(self)
            if frequency_cap(self) then return create_response(status.TOO_MANY_REQUESTS) end
            local key = self:stash('id')
            local data = parse_request(self)
            if data then
                _put(key, data.value)
                return create_response(status.OK)
            end
            return create_response(status.BAD_REQUEST)
        end,

    del = function(self)
            if frequency_cap(self) then return create_response(status.TOO_MANY_REQUESTS) end
            local key = self:stash('id')
            _del(key)
            return create_response(status.OK)
        end
}
