-- controller.main

local json   = require 'json'
local config = require 'config'

local status = config.status
local space  = box.space[config.space]

local function create_response(status, body)
    if body then body = json.encode(body) end
    return {
        ['status']  = status,
        ['headers'] = { ['content-type'] = 'application/json; charset=utf8' },
        ['body']    = body
    }
end

local function parse_request(req)
    return req:json()
end

function _get(key)
    local data = space:get { key }
    if data then return data[config.data_field] end
end

function _set(key, val)
    space:insert { key, val }
end

function _put(key, val)
    space:update( { key }, { { '=', config.data_field, val } } )
end

function _del(key)
    space:delete { key }
end

return {
    post = function(self)
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
            local id = self:stash('id')
            local data = _get(id)
            if data then
                return create_response(status.OK, data)
            end
            return create_response(status.NO_CONTENT)
        end,

    put = function(self)
            local key = self:stash('id')
            local data = parse_request(self)
            if data then
                _put(key, data.value)
                return create_response(status.OK)
            end
            return create_response(status.BAD_REQUEST)
        end,

    del = function(self)
            local key = self:stash('id')
            _del(key)
            return create_response(status.OK)
        end
}
