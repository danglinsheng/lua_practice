function get_filename_from_header(headerline) 
	local filename = ngx.re.match(headerline, '(.+)filename="(.+)"(.*)') 
	if filename then  
		return filename[2] 
	end 
end 

function do_uploadf()
	local upload = require "resty.upload" 
	local chunk_size = 4096 
	local save_filepath = "/tmp/" 
	local fd 
	local filelen=0 
	local filename 

	local form = upload:new(chunk_size) 
	form:set_timeout(0) 

	while true do 
		local typ, res, err = form:read() 
		if not typ then 
			ngx.say("failed to read: ", err) 
			return 
		end

		if typ == "header" then 
			if res[1] ~= "Content-Type" then 
				filename = get_filename_from_header(res[2]) 
				local filepath = save_filepath  .. filename 
				fd = io.open(filepath, "w+") 
			end
			if not fd then 
				ngx.say("failed to open file ") 
				return 
			end 
		end 
		elseif typ == "body" then 
			if fd then 
				filelen = filelen + tonumber(string.len(res))     
				fd:write(res) 
			end 
		elseif typ == "part_end" then 
			if fd then 
				fd:close() 
				fd = nil 
				ngx.say("File " .. filename .. " upload success") 
			end 
		elseif typ == "eof" then 
				break 
		end 
	end
end

local _M = {
	do_uploadf = do_uploadf,
}

return _M

