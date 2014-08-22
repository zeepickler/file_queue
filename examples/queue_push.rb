require './lib/queue_connect.rb'
@queue = QueueConnect.queue('127.0.0.1:61676','hash_queue')

msg = {'a' => 1}

@queue.push_msg msg