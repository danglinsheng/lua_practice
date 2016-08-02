local function create_memc_instance()
	local memc = require "resty.memcached"
	local m = memc:new()
	if not m then
		ngx.say("failed to instantiate memc: ", err)
		return
	end
	m:set_timeout(3000)

	local status, error = m:connect("127.0.0.1", 11211)
	if not status then
		ngx.say("Failed to connect memcached 127.0.0.1:11211 for ", error)
		m = nil
	end

	return m
end

local function close_memc_instance(m)
	return m:set_keepalive(10000, 100)

	--return m:close()
end

local function set(m, k, v)
	return m:set(k, v)
end

local function get(m, k)
	return m:get(k)
end

local function set_data()
	local m = create_memc_instance()
	if not m then
		ngx.say("Failed to create_memc_instance")
		return
	end
	local status, error = set(m, ngx.var.arg_k, ngx.var.arg_v)
	if not status then
		ngx.say("Failed to setkey for ", error)
		return
	end

	status, error = close_memc_instance(m)
	if not status then
		ngx.say("Failed to close memcached for ", error)
		return
	end
end


local function get_data()
	local m = create_memc_instance()
	if not m then
		ngx.say("Failed to create_memc_instance")
		return
	end

	local status, error = get(m, ngx.var.arg_k)
	if not status then
		ngx.say("Failed to getkey for ", error)
		return
	end

	if status == ngx.null then
		ngx.say(ngx.var.arg_k .. " not found.")
		return
	end

	ngx.say("Get " .. ngx.var.arg_k .. " : " .. status)

	status, error = close_memc_instance(m)
	if not status then
		ngx.say("Failed to close memcached for ", error)
		return
	end
end

local function get_data_bykey(key)
	local m = create_memc_instance()
	if not m then
		ngx.say("Failed to create_memc_instance")
		return
	end

	local status, error = get(m, key)
	if not status then
		ngx.say("Failed to getkey for ", error)
		return
	end

	if status == ngx.null then
		ngx.say(key .. " not found.")
		return
	end

	local result = status

	status, error = close_memc_instance(m)
	if not status then
		ngx.say("Failed to close memcached for ", error)
		return
	end

	return result
end

local function getinfo()
	ngx.say("I am memcached")
	return "I am memcached"
end

local _M = {
	setdata = set_data,
	getdata = get_data,
	getdata_bykey = get_data_bykey,
	getinfo = getinfo,
}

return _M
