require 'mqtt'
require 'timeout'
class Motor
  def intialize
    # `stopped` | `running` | `error`
    @state = 'stopped'
  end

  def self.on(status)
    @state = status
    message = status ? "running" : "stopped"
    client = MqttClient.instance.client
    # publish "start/stop" request
    client.publish('/request', message)
    # wait for response from esp32
    begin
      Timeout::timeout(2) do
        client.get('/response') do |topic, message|
          # esp should return `running`/`stopped`
          @state = message
          break
        end
      end
    rescue Timeout::Error
      @state = "error"
    end
  end

  def self.state
    return @state
  end

  def self.running?
    @state == 'running'
  end
end
