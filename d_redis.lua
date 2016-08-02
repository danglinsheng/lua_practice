local function create_redis_instance()
	local redis = require "resty.redis"
	local r = redis:new()
	r:set_timeout(3000)

	local status, error = r:connect("127.0.0.1", 6379)
	if not status then
		ngx.say("Failed to connect redis 127.0.0.1:6379 for ", error)
		r = nil
	end

	return r
end

local function close_redis_instance(r)
	return r:set_keepalive(10000, 100)

	--return r:close()
end

local function set(r, k, v)
	return r:set(k, v)
end

local function get(r, k)
	return r:get(k)
end

local function set_data()
	local r = create_redis_instance()
	if not r then
		ngx.say("Failed to create_redis_instance")
		return
	end

	local status, error = set(r, ngx.var.arg_k, ngx.var.arg_v)
	if not status then
		ngx.say("Failed to setkey for ", error)
		return
	end

	status, error = close_redis_instance(r)
	if not status then
		ngx.say("Failed to close redis for ", error)
		return
	end
end

local function set_data_bykeyval(key, val)
	local r = create_redis_instance()
	if not r then
		ngx.say("Failed to create_redis_instance")
		return
	end

	local status, error = set(r, key, val)
	if not status then
		ngx.say("Failed to setkey for ", error)
		return
	end

	status, error = close_redis_instance(r)
	if not status then
		ngx.say("Failed to close redis for ", error)
		return
	end
end


local function get_data()
	local r = create_redis_instance()
	if not r then
		ngx.say("Failed to create_redis_instance")
		return
	end

	local status, error = get(r, ngx.var.arg_k)
	if not status then
		ngx.say("Failed to getkey for ", error)
		return
	end

	if status == ngx.null then
		ngx.say(ngx.var.arg_k .. " not found.")
		return
	end

	ngx.say(status)

	status, error = close_redis_instance(r)
	if not status then
		ngx.say("Failed to close redis for ", error)
		return
	end
end

local function get_data_bykey(key)
	local r = create_redis_instance()
	if not r then
		ngx.say("Failed to create_redis_instance")
		return nil
	end

	local status, error = get(r, key)
	if not status then
		ngx.say("Failed to getkey for ", error)
		return nil
	end

	if status == ngx.null then
		ngx.say(key .. " not found.")
		return nil
	end

	--ngx.say(status)
	local result = status

	status, error = close_redis_instance(r)
	if not status then
		ngx.say("Failed to close redis for ", error)
		return nil
	end
	
	return result
end

local function set_get_data()
	local r = create_redis_instance()
	if not r then
		ngx.say("Failed to create_redis_instance")
		return
	end

	local status, error = set(r, ngx.var.arg_k, ngx.var.arg_v)
	if not status then
		ngx.say("Failed to setkey for ", error)
		return
	end

	status, error = get(r, ngx.var.arg_k)
	if not status then
		ngx.say("Failed to getkey for ", error)
		return
	end

	if status == ngx.null then
		ngx.say(ngx.var.arg_k .. " not found.")
		return
	end

	ngx.say(status)

	status, error = close_redis_instance(r)
	if not status then
		ngx.say("Failed to close redis for ", error)
		return
	end
end


local _M = {
	setdata = set_data,
	getdata = get_data,
	getdata_bykey = get_data_bykey,
	setdata_bykeyval = set_data_bykeyval,
	setgetdata = set_get_data,
}

return _M
