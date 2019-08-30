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
    client.publish('/request', message)
    begin
      Timeout::timeout(2) do
        client.get('/response') do |topic, message|
          # esp should return `running`/`stopped`/`error`
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
