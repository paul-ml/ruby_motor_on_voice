require 'mqtt'
require 'timeout'
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
    begin
      Timeout::timeout(2) do
        client.get('response') do |topic, message|
          # esp should return `running`/`stopped`/`error`
          @state = message
        end
      end
    rescue Timeout::Error
      @state = "timeout"
    end
  end

  def self.running?
    @state == 'running'
  end
end
