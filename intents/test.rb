# coding: utf-8
motor_running = false

intent "LaunchRequest" do
   ask("Hello, How can I help you today ?")
end

intent "MotorOnIntent" do
  if motor_running
    tell("Motor has already started running")
  else
    motor_running = true
    tell("Starting motor now.")
  end
end

intent "MotorOffIntent" do
  if motor_running
    motor_running = false
    tell("Motor will be stopped now.")
  else
    tell("Motor has already stopped running")
  end
end

intent "MotorStatusIntent" do
  if motor_running
    ask("Motor is running. Do I need to stop motor now ?", session_attributes: { persist: "running" })
  else
    ask("motor is free for use. Do I need to start motor now ?", session_attributes: { persist: "not_running" })
  end
end

intent "YesIntent" do
  persisted_data = request.session_attribute("persist")
  if persisted_data == "running"
    motor_running = false
    tell("Motor will be stopped now.")
  else
    motor_running = true
    tell("Starting motor now.")
  end
end

intent "NoIntent" do
  tell("Got it. Waiting to serve you again later.")
end
