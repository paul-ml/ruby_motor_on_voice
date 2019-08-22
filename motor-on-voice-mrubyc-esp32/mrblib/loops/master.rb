#initialise_wifi()
# http_client_init("https://333f7895.ngrok.io/motor/status")
# while true
#   if connected_to_network
#     response = send_http_request()
#     puts response
#     sleep(2)
#   end
# end
# http_client_cleanup()
servo_gpio_initialize()
servo_control()
puts "second turn after 5 seconds"
sleep(5)
servo_control()
puts "second turn after 5 seconds"
sleep(5)
servo_control()
puts "second turn after 5 seconds"
sleep(5)
servo_control()
puts "second turn after 5 seconds"
sleep(5)
servo_control()
