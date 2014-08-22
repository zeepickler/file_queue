require "./lib/queue_server.rb"

if ARGV[0].nil? || ARGV.size > 1
 	puts "Please provide an url for the queue ie. 'ruby start_queue.rb 127.0.0.1:61676'"
	exit 0
end
QueueServer.new(ARGV[0])