worker_processes  1;
error_log logs/error.log;

events {
    worker_connections 1024;
}

http {

	lua_need_request_body on;
	
	log_format muisformat 'MUIS6 : [$time_local] (remote_addr:$remote_addr) (remote_user:$remote_user) (request:$request) (status:$status) (body_bytes_sent:$body_bytes_sent) (http_referer:$http_referer) (http_user_agent:$http_user_agent) (http_x_forwarded_for:$http_x_forwarded_for) (request_id:$request_id) (scheme:$scheme) (server_addr:$server_addr) (server_port:$server_port) (uri:$uri) (request_method:$request_method) (query_string:$query_string) (content_length:$content_length) (request_body:$request_body) (resp_body:$resp_body)';
			
server {

  listen 8089 default_server;

  lua_need_request_body on;

  set $resp_body "";
  set $req_body "";
  set $req_headers "";

  client_body_buffer_size 16k;
  client_max_body_size 16k;

  rewrite_by_lua_block {
            local req_headers = "Headers: ";
            ngx.var.req_body = ngx.req.get_body_data();
            local h, err = ngx.req.get_headers()
            for k, v in pairs(h) do
                req_headers = req_headers .. k .. ": " .. v .. "\n";
            end

            ngx.var.req_headers = req_headers;
  }

  body_filter_by_lua '
        local resp_body = string.sub(ngx.arg[1], 1, 1000)
        ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body
        if ngx.arg[2] then
          ngx.var.resp_body = ngx.ctx.buffered
        end
  ';


    location / {
		default_type text/html;
		content_by_lua_block {
			ngx.say("<p>hello, worldd</p>")
		}
	}
	
  access_log  /home/msentissi/fuse-backend/open_resty_lab/logs/req-resp.log muisformat;
}

}
