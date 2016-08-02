local function create_dns_resolver( )
	local resolver = require "resty.dns.resolver"
	return resolver:new{ nameservers = { { "10.103.10.5", 53}, { "10.103.52.23" }, { "10.103.10.6", 53}, { "10.103.52.24" } } ,
	retrans = 5,
	timeout = 2000,	 
}
end

local function do_query(resolver, domain)
	return resolver:query(domain)
end

local function parse_result(results)
	for i, ans in ipairs(results) do
		ngx.say(ans.name, " ", ans.address or ans.cname, " type:", ans.type, " class:", ans.class, " ttl:", ans.ttl)
	end
end


local function query()
	local res, err = create_dns_resolver()
	if not res then
		ngx.say("Failded to create_dns_resolver for ", err)
		return
	end

	local results, err = do_query(res, ngx.var.arg_d)
	if not results then
		ngx.say("Failded to do_query for ", err)
		return
	end

	if results.errcode then
		ngx.say("server returned error code: ", results.errcode, ": ", results.errstr)
	end

	parse_result(results)
end


local _M = {
query = query,
}

return _M
