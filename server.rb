require 'websocket-eventmachine-server'

EM.epoll
EM.run do

  trap("TERM") { stop }
  trap("INT")  { stop }

  WebSocket::EventMachine::Server.start(:host => "0.0.0.0", :port => 3000) do |ws|

    ws.onopen do
      puts "Client connected"
      ws.send "connection", :type => :text
    end

    ws.onmessage do |msg, type|
      puts "Received message: #{msg}"
      ws.send "server: #{msg}", :type => type
    end

    ws.onclose do
      puts "Client disconnected"
    end

    ws.onerror do |e|
      puts "Error: #{e}"
    end

    ws.onping do |msg|
      puts "Receied ping: #{msg}"
    end

    ws.onpong do |msg|
      puts "Received pong: #{msg}"
    end

  end

  puts "Server started at port 3000"

  def stop
    puts "Terminating WebSocket Server"
    EventMachine.stop
  end

end
