	@@master_queue_dir = "./queue"

	# queue actions
	@@actions = [
		'produce',
		'consume'
	]

	#file extensions for message status
	@@sent_msg_ext = ".msg_pushed"
	@@received_msg_ext = ".msg_received"
	@@delete_msg_ext = ".delete_msg"

	def initialize(queue_name,action)
		case action 
		when @@actions[0]
			Dir.mkdir(@@master_queue_dir) unless Dir.exist?(@@master_queue_dir)

			queue_dir = File.join(@@master_queue_dir,queue_name)
			Dir.mkdir(queue_dir) unless Dir.exists?(queue_dir)
			
			producer_name = Time.now.to_i.to_s + rand(100000000).to_s
			
			@producer_id = File.join(queue_dir,producer_name)

		when @@actions[1]
			@queue_dir = File.join(@@master_queue_dir,queue_name)
			raise "Queue doesn't exist" unless Dir.exists?(@queue_dir)
		else
			raise "Invalid action. Valid actions: #{@@actions.join(", ")}"
		end 
	end
	def push msg
		filename = @producer_id + Time.now.to_i.to_s + Time.now.usec.to_s + @@sent_msg_ext
		f = File.open(filename,"w")
		f.puts(msg.to_json)
		f.close
	end
	def pull
		file = `find "#{@queue_dir}" -type f -iname \*#{@@sent_msg_ext} | head -1`.chomp
		if file.empty?
			return nil
		else
			# acknowledge message first (quickly)
			got_file = File.join(@queue_dir,File.basename(file, ".*").to_s + @@received_msg_ext)
			`mv "#{file}" "#{got_file}"`
			# get msg contents
			msg = File.read(got_file)
			# flag to delete message
			# cron job will delete these files
			rm_file = File.join(@queue_dir,File.basename(file, ".*").to_s + @@delete_msg_ext)
			`mv "#{got_file}" "#{rm_file}"`
			# return msg contents
			return JSON.parse(msg)
		end
	end
end

##############
# Example

# msg = {'a' => 1}

# start = Time.now
# @qp = Queue.new("hash_queue","produce")
# 1000.times{ @qp.push msg } 
# puts "Push took: #{Time.now - start}" # 0.118564 

# start = Time.now
# @qc = Queue.new("hash_queue","consume")
# 1000.times{ @qc.pull }
# puts "Pull took: #{Time.now - start}" # 31.378936



