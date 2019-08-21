initialise_wifi()
puts CONFIG_ESP_MQTT_URI
while true
  if connected_to_network
    if connected_to_mqqt_broker
      puts "woho !! connected to mqtt"
    else
      mqtt_app_start()
    end
    puts "connected to network"
  end
  sleep(2)
end
