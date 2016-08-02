function f()
	ngx.sleep(0.2)
	ngx.say("f: hello")
	return "f done"
end

function g()
	ngx.sleep(0.1)
	ngx.say("g: hello")
	return "g done"
end

local tf, err = ngx.thread.spawn(f)
if not tf then
	ngx.say("failed to spawn thread f: ", err)
	return
end

ngx.say("f thread created: ", coroutine.status(tf))

local tg, err = ngx.thread.spawn(g)
if not tg then
	ngx.say("failed to spawn thread g: ", err)
	return
end

ngx.say("g thread created: ", coroutine.status(tg))

local ok, err = ngx.thread.kill(tg)
if not ok then
	ngx.say("failed to kill thread g: ", err)
	return
end

local ok1, res1 = ngx.thread.wait(tg)
local ok2, res2 = ngx.thread.wait(tf)
ngx.say("res1: ", res1)
ngx.say("res2: ", res2)

local tf, err = ngx.thread.spawn(f)
if not tf then
	ngx.say("failed to spawn thread f: ", err)
	return
end

ngx.say("f thread created: ", coroutine.status(tf))

local tg, err = ngx.thread.spawn(g)
if not tg then
	ngx.say("failed to spawn thread g: ", err)
	return
end

ngx.say("g thread created: ", coroutine.status(tg))

local ok, res = ngx.thread.wait(tg, tf)
ngx.say("res: ", res)

ngx.exit(ngx.OK)
