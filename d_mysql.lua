local function create_mysql_instance()
	local mysql = require "resty.mysql"
	local db = mysql:new()
	db:set_timeout(3000)

	local status, error = db:connect{ host = "127.0.0.1", port = 3306, database = "mysql", user = "root"}
	if not status then
		ngx.say("Failed to connect mysql 127.0.0.1:3306 for ", error)
		db = nil
	end

	return db
end

local function close_mysql_instance(db)
	return db:set_keepalive(10000, 100)

	--return db:close()
end

local function get(db, t, k, v)
	return db:query("select * from " .. t .. " where " .. k .. " = " .. "'" .. v .. "'")	
end

local function get_data()
	local db = create_mysql_instance()
	if not db then
		ngx.say("Failed to create_mysql_instance")
		return
	end

	local status, error, errno, sqlstate = get(db, ngx.var.arg_t, ngx.var.arg_k, ngx.var.arg_v)
	if not status then
		ngx.say("Bad result for ", error, errno, sqlstate)
		return
	end

	local cjson = require "cjson"
	ngx.say(cjson.encode(status))

	status, error = close_mysql_instance(db)
	if not status then
		ngx.say("Failed to close mysql for ", error)
		return
	end
end

local function getdata_bykey(table, key, val)
	local db = create_mysql_instance()
	if not db then
		ngx.say("Failed to create_mysql_instance")
		return
	end

	local status, error, errno, sqlstate = get(db, table, key, val)
	if not status then
		ngx.say("Bad result for ", error, errno, sqlstate)
		return
	end

	local cjson = require "cjson"

	local result = cjson.encode(status)
	ngx.say(result)

	status, error = close_mysql_instance(db)
	if not status then
		ngx.say("Failed to close mysql for ", error)
		return
	end

	return result
end

local function getinfo()
	ngx.say("I am mysql")
	return "I am mysql"
end

local _M = {
	getdata = get_data,
	getdata_bykey = getdata_bykey,
	getinfo = getinfo,
}

return _M
