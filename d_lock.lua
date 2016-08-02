local function fetch_redis(key)
	local redis = require "d_redis"
	return redis.getdata_bykey(key)
end

local function query()
	local resty_lock = require "resty.lock"
    local cache = ngx.shared.my_cache

    -- step 1:
    local val, err = cache:get(ngx.var.arg_key)
    if val then
        ngx.say("result 1: ", val)
        return
    end

    if err then
        ngx.say("failed to get key from shm: ", err)
    end

    -- cache miss!
    -- step 2:
    local lock = resty_lock:new("my_locks")
    local elapsed, err = lock:lock(ngx.var.arg_key)
    if not elapsed then
        ngx.say("failed to acquire the lock: ", err)
    end


    -- lock successfully acquired!

    -- step 3:
    -- someone might have already put the value into the cache
    -- so we check it here again:
    val, err = cache:get(ngx.var.arg_key)
    if val then
        local ok, err = lock:unlock()
        if not ok then
            ngx.say("failed to unlock: ", err)
        end

        ngx.say("result 2: ", val)
        return
    end

    --- step 4:
    local val = fetch_redis(ngx.var.arg_key)
    if not val then
        local ok, err = lock:unlock()
        if not ok then
            ngx.say("failed to unlock: ", err)
        end

        -- FIXME: we should handle the backend miss more carefully
        -- here, like inserting a stub value into the cache.

        ngx.say("no value found")
        return
    end

	ngx.say(ngx.var.arg_key .. " : " .. val)

    -- update the shm cache with the newly fetched value
    local ok, err = cache:set(ngx.var.arg_key, val, 0)
    if not ok then
        local ok, err = lock:unlock()
        if not ok then
            ngx.say("failed to unlock: ", err)
        end

        return fail("failed to update shm cache: ", err)
    end

    local ok, err = lock:unlock()
    if not ok then
        ngx.say("failed to unlock: ", err)
    end

    ngx.say("result: ", val)
end

local _M = {
	query = query,
}

return _M
