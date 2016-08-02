local function create_wbc()
    local client = require "resty.websocket.client"
    return client:new()
end


local function serv()
    local wb, err = create_wbc()
    if not wb then
        ngx.log(ngx.ERR, "failed to new websocket: ", err)
        return ngx.exit(444)
    end

    local uri = "ws://10.100.47.63:8079/wbs"
    local ok, err = wb:connect(uri)
    if not ok then
        ngx.say("failed to connect: " .. err)
        return
    end

    local data, typ, err = wb:recv_frame()
    ngx.say("received: ", data, " (", typ, "): ", err)

    local bytes, err = wb:send_text("hello world")
    local data, typ, err = wb:recv_frame()
    ngx.say("received: ", data, " (", typ, "): ", err)

    bytes, err = wb:send_binary("blah blah blah...")
    local data, typ, err = wb:recv_frame()
    ngx.say("received: ", data, " (", typ, "): ", err)

    wb:send_close()
end

local _M = {
    serv = serv,
}

return _M
