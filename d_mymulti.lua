local function my_multi(uris)
	local thread = {}

	for k, v in pairs(uris) do
		thread[k] = ngx.thread.spawn(v, "user", "host", "localhost")
	end

	for i = 1, #thread do
		local ok, res = ngx.thread.wait(thread[i])
		ngx.say(res)
	end

end


local function memc_redis_mysql()
	local memc = require "d_memcached"
	local redis = require "d_redis"
	local mysql = require "d_mysql"

	local uris = {}
	table.insert(uris, memc.getdata_bykey)
	table.insert(uris, redis.getdata_bykey)
	table.insert(uris, mysql.getdata_bykey)

	my_multi(uris)

end


local _M = {
	memc_redis_mysql = memc_redis_mysql,
}

return _M
