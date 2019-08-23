require 'mqtt'
class Motor
  def intialize
    # `stopped` | `running` | `error`
    @state = 'stopped'
  end

  def self.on(status)
    @state = status
    message = status ? "Run" : "Stop"
    client = MqttClient.instance.client
    client.publish('request', message)
    client.get('response') do |topic, message|
      # esp should return `running`/`stopped`/`error`
      @state = message
    end
  end

  def self.running?
    @state == 'running'
  end
end
