require 'mqtt'
class Motor
  def intialize
    @running = false
    @client = nil
  end

  def self.on(status)
    @running = status
    message = status ? "Running" : "Stopped"
    client = MqttClient.instance.client
    topic = ENV["MQTT_TOPIC"]
    self.init_mqtt
    client.publish(topic, message)
  end

  def self.running?
    return @running
  end
end
