-- Config

return {
    host    = '192.168.112.132',
    port    = 8080,
    space   = 'kv_tmp_10007',
    routes  = {
        { name = 'post', path = '/kv',     method = 'POST'   },
        { name = 'put',  path = '/kv/:id', method = 'PUT'    },
        { name = 'get',  path = '/kv/:id', method = 'GET'    },
        { name = 'del',  path = '/kv/:id', method = 'DELETE' },
    },
    params = {
        log_requests = true,
    },
    data_field = 2,
    format = {
        { name = '_key', type = 'scalar' },
        { name = '_val', type = 'any' },
    },
    status = {
        OK                = 200,
        NO_CONTENT        = 204,
        BAD_REQUEST       = 400,
        NOT_FOUND         = 404,
        CONFLICT          = 409,
        TOO_MANY_REQUESTS = 429,
    },
}