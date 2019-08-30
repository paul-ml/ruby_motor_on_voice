# coding: utf-8
require './lib/motor'
require './lib/config'

intent "LaunchRequest" do
   ask("Hello, How can I help you today ?")
end

intent "MotorOnIntent" do
  if Motor.running?
    tell("Motor has already started running")
  else
    Motor.on(true)
    case Motor.state
    when 'running'
      tell("Starting motor now.")
    when 'error'
      tell(Config::ERROR_MESSAGE)
    when 'timeout'
      tell(Config::TIME_OUT_MESSAGE)
    end
  end
end

intent "MotorOffIntent" do
  if Motor.running?
    Motor.on(false)
    case Motor.state
    when 'stopped'
      tell("Motor will be stopped now.")
    when 'error'
      tell(Config::ERROR_MESSAGE)
    when 'timeout'
      tell(Config::TIME_OUT_MESSAGE)
    end
  else
    tell("Motor has already stopped running")
  end
end

intent "MotorStatusIntent" do
  if Motor.running?
    ask("Motor is running. Do I need to stop motor now ?", session_attributes: { persist: "running" })
  else
    ask("motor is free for use. Do I need to start motor now ?", session_attributes: { persist: "not_running" })
  end
end

intent "YesIntent" do
  persisted_data = request.session_attribute("persist")
  if persisted_data == "running"
    Motor.on(false)
    tell("Motor will be stopped now.")
  else
    Motor.on(true)
    tell("Starting motor now.")
  end
end

intent "NoIntent" do
  tell("Got it. Waiting to serve you again later.")
end

intent "SessionEndedRequest" do
  respond("Hmm. something went wrong. Please try again later")
end
