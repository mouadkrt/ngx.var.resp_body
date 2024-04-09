local setmetatable = setmetatable

local _M = require('apicast.policy').new('muis_log_payload', '0.1')
local mt = { __index = _M }


function _M:init()
  -- do work when nginx master process starts
end

function _M:init_worker()
  -- do work when nginx worker process is forked from master
end

function _M:access()
  -- ability to deny the request before it is sent upstream
end

function _M:content()
  -- can create content instead of connecting to upstream
end

function _M:post_action()
  -- do something after the response was sent to the client
end

function _M:header_filter()
  -- can change response headers
end

function _M:rewrite()
-- Load http body into memory
  ngx.req.read_body()
  body = ngx.req.get_body_data()

  ngx.log(ngx.INFO, "Request Body : " .. body)
end

function _M:body_filter()
  -- can read and change response body
  -- https://github.com/openresty/lua-nginx-module/blob/master/README.markdown#body_filter_by_lua
  
  -- Get RESPONSE BODY :
    local resp_body = ngx.arg[1]
    ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body
    if ngx.arg[2] then
      ngx.var.resp_body = ngx.ctx.buffered
    end
	
  -- Get RESONSE HEADERS :
  -- local resp_headers = "";
  -- local h, err = ngx.resp.get_headers()
  --  for k, v in pairs(h) do
  --      resp_headers = resp_headers .. "[" .. k .. ": " .. v .. "] ";
  --  end
  --  ngx.var.resp_headers = resp_headers;

   ngx.log(ngx.INFO, "RESPONSE BODY : " .. resp_body) -- Will get logged to $APICAST_LOG_FILE deployment env var
	
end

function _M:log()
  -- can do extra logging
end

function _M:balancer()
  -- use for example require('resty.balancer.round_robin').call to do load balancing
end

return _M
