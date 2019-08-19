initialise_wifi()
http_client_init("http://httpbin.org/get")
while true
  if connected_to_network
    send_http_request()
    sleep(2)
  end
end
http_client_cleanup()
