require 'mqtt'
class Motor
  def intialize
    @running = false
  end

  def self.on(status)
    @running = status
    message = status ? "Running" : "Stopped"
    conn_opts = {
      remote_host: ENV["MQTT_HOST"],
      remote_port: ENV["MQTT_PORT"],
      username: ENV["MQTT_USERNAME"],
      password: ENV["MQTT_PASSWORD"]
    }
    client = MQTT::Client.connect(conn_opts)
    topic = ENV["MQTT_TOPIC"]
    client = Motor.init_mqtt_broker
    client.publish(topic, message)
  end

  def self.running?
    return @running
  end
end
