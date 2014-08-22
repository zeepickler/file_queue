require 'drb'
require 'json'

class QueueConnect
	def self.queue(uri,queue_name)
		DRb.start_service
		@queue = DRbObject.new_with_uri("druby://#{uri}")
		@queue.new_queue queue_name # won't hurt anyting if it already exists
		return @queue
	end
end
