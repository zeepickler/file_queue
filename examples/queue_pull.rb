require './lib/queue_connect.rb'
@queue = QueueConnect.queue('127.0.0.1:61676','hash_queue')

puts @queue.pull_msg
