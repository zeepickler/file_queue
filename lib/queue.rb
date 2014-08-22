require 'json'
class Queue
	@@master_queue_dir = "./queue"

	#file extensions for message status
	@@sent_msg_ext = ".msg_pushed"
	@@received_msg_ext = ".msg_received"
	@@delete_msg_ext = ".delete_msg"

	def initialize
		Dir.mkdir(@@master_queue_dir) unless Dir.exist?(@@master_queue_dir)
		@user_id = Time.now.to_i.to_s + rand(100000000).to_s
	end
	def new_queue(queue_name)
		@queue_dir = File.join(@@master_queue_dir,queue_name)
		Dir.mkdir(@queue_dir) unless Dir.exists?(@queue_dir)
	end
	def push_msg(msg)
		file_name = @user_id + Time.now.to_i.to_s + Time.now.usec.to_s + @@sent_msg_ext
		file_path = File.join(@queue_dir,file_name)
		f = File.open(file_path,"w")
		f.puts(msg.to_json)
		f.close
	end
	def pull_msg
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



