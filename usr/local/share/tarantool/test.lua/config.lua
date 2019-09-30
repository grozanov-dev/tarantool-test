-- Config

return {
    host    = '192.168.112.132',
    port    = 8080,
    routes  = {
        { name = 'post', path = '/kv',     method = 'POST'   },
        { name = 'put',  path = '/kv/:id', method = 'PUT'    },
        { name = 'get',  path = '/kv/:id', method = 'GET'    },
        { name = 'del',  path = '/kv/:id', method = 'DELETE' },
    },
    params = {
        log_requests = true,
    },
    spaces = {
        data = {
            name = 'kv_tmp_10009',
            data_field = 2,
            key_field = '_key',
            format = {
                { name = '_key', type = 'scalar' },
                { name = '_val', type = 'any' },
            },
        },
        arbiter = {
            name = 'freq_arbiter_0005',
            key_field = '_id',
            format = {
                { name = '_id', type = 'scalar' },
                { name = '_bucket', type = 'unsigned' },
                { name = '_ts', type = 'number' },
            },
            tuples_per_iteration = 50,
            max_requests_per_ttl = 10,
            sleep = 1,
            ttl = 1,
            key = 'test_key', -- В перспективе возможно усложнить индекс, сделав fcap для конкретного IPшника
        },
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