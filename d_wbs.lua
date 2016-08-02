local function create_wbs()
  local server = require "resty.websocket.server"
  return server:new{
    timeout = 5000,  -- in milliseconds
    max_payload_len = 65535,
  }
end


local function serv()
  local wb, err = create_wbs()
  if not wb then
    ngx.log(ngx.ERR, "failed to new websocket: ", err)
    return ngx.exit(444)
  end

  while true do
   wb:send_text("welcome to websocket")
   local data, typ, err = wb:recv_frame()
   if not data then
    ngx.log(ngx.ERR, "failed to receive a frame: ", err)
    return ngx.exit(444)
    elseif typ == "close" then break

     elseif typ == "ping" then
       local bytes, err = wb:send_pong()
       if not bytes then
        ngx.log(ngx.ERR, "failed to send pong: ", err)
        return ngx.exit(444)
      end
      elseif typ == "pong" then
       ngx.log(ngx.INFO, "client ponged")
       elseif typ == "text" then
         local bytes, err = wb:send_text(data)
         if not bytes then
          ngx.log(ngx.ERR, "failed to send text: ", err)
          return ngx.exit(444)
        end

        bytes, err = wb:send_binary("blah blah blah...")
        if not bytes then
          ngx.log(ngx.ERR, "failed to send a binary frame: ", err)
          return ngx.exit(444)
        end
      end
    end

    wb:send_close()

end

local _M = {
  serv = serv,
}

return _M
