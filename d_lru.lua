local function create_lru(count)
	local lrucache = require "resty.lrucache"

	return lrucache.new(count)
end

local function go()
	local cache = create_lru(10)
	if not cache then
		ngx.say("failted to create lru cache")
		return
	end

	cache:set("aaa", 11)
	cache:set("bbb", 12)
	cache:set("ccc", 13)
	cache:set("ddd", 14)
	cache:set("eee", 15, 0.1)
	cache:set("fff", 16, 10)
	cache:set("ggg", 17)
	cache:set("hhh", 18)
	cache:set("iii", 19)
	cache:set("jjj", 20)
	cache:set("kkk", 21)
	
	ngx.say("aaa: ", cache:get("aaa"))
	ngx.say("eee: ", cache:get("eee"))
	ngx.say("fff: ", cache:get("fff"))
	ngx.say("jjj: ", cache:get("jjj"))
	ngx.say("kkk: ", cache:get("kkk"))
	ngx.say("")

	ngx.sleep(0.15)

	ngx.say("aaa: ", cache:get("aaa"))
	ngx.say("eee: ", cache:get("eee"))
	ngx.say("fff: ", cache:get("fff"))
	ngx.say("jjj: ", cache:get("jjj"))
	ngx.say("kkk: ", cache:get("kkk"))
	ngx.say("")

	cache:delete("jjj")

	ngx.say("aaa: ", cache:get("aaa"))
	ngx.say("eee: ", cache:get("eee"))
	ngx.say("fff: ", cache:get("fff"))
	ngx.say("jjj: ", cache:get("jjj"))
	ngx.say("kkk: ", cache:get("kkk"))
	ngx.say("")
	
end

local _M = {
	go = go,
}

return _M
