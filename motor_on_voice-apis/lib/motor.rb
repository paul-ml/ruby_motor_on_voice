require 'mqtt'
class Motor
  def intialize
    @running = false
    @client = nil
  end

  def self.init_mqtt
    if @client.nil?
      conn_opts = {
        remote_host: ENV["MQTT_HOST"],
        remote_port: ENV["MQTT_PORT"],
        username: ENV["MQTT_USERNAME"],
        password: ENV["MQTT_PASSWORD"]
      }
      @client = MQTT::Client.connect(conn_opts)
    end
  end

  def self.on(status)
    @running = status
    message = status ? "running" : "stopped"
    topic = ENV["MQTT_TOPIC"]
    self.init_mqtt
    @client.publish(topic, message)
  end

  def self.running?
    return @running
  end
end
