initialise_wifi()
while true
  if connected_to_network
    if connected_to_mqqt_broker
      puts "woho !! connected to mqtt"
      if new_request
        puts "received_message is .. " + received_message
      end
    else
      mqtt_app_start()
    end
    puts "connected to network"
  end
  sleep(2)
end
