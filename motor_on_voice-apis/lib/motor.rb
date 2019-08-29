require 'mqtt'
require 'timeout'
class Motor
  def intialize
    # `stopped` | `running` | `error`
    @state = 'stopped'
    Motor.on(false)
  end

  def self.on(status)
    message = status ? "running" : "stopped"
    client = MqttClient.instance.client
    client.publish('/request', message)
    begin
      Timeout.timeout(3){
        client.get('/response') do |topic, message|
            # esp should return `running`/`stopped`/`error`
            @state = message
            break
        end
      }
    rescue Timeout::Error
      @state = "error"
    end
  end

  def self.connected?
    client = MqttClient.instance.client
    client.publish('/request', "connection_tester")
    begin
      Timeout.timeout(3){
        client.get('/response') do |topic, message|
          break
        end
      }
    rescue Timeout::Error
      @state = "error"
      return false
    end
    return true
  end

  def self.running?
    @state == "running"
  end
end
