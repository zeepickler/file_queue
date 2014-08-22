require 'drb'
require './lib/queue.rb'
class QueueServer
	def initialize(ip_address)
		DRb.start_service("druby://#{ip_address}",Queue.new)
		puts "Listening for connection..."
		DRb.thread.join
	end
end

# QueueServer.new("127.0.0.1:61676")