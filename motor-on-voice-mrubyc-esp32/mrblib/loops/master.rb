SERVO_MAX_DEGREE = 90
initialise_wifi()
motor = Motor.new(18, 50, 0, 0)
mqtt_retry = 0
while true
  if connected_to_network
    if connected_to_mqqt_broker
      mqtt_retry = 0
      if motor.start?
        for count in 0...SERVO_MAX_DEGREE
            #puts "running...."
            #printf("Angle of rotation: %d\n", count);
            angle = motor.calc_pulsewidth(count)
            #printf("pulse width: %dus\n", angle);
            run_servo(angle)
            #mcpwm_set_duty_in_us(MCPWM_UNIT_0, MCPWM_TIMER_0, MCPWM_OPR_A, angle);
            sleep(0.002)     #Add delay, since it takes time for servo to rotate, generally 100ms/60degree rotation at 5V
        end
      else
        sleep(1)
      end
    else
      if mqtt_retry < 1
        mqtt_retry += 1
        mqtt_app_start()
      end
      sleep(2)
    end
  else
    puts "connecting to network"
    sleep(2)
  end
end
