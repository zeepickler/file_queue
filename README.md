File Queue - A File-Based queue system

Synopsis:

While reading from files is slower than reading from RAM, this is a rugged solution as the messages will persist.

Usage:

To start the queue server, run 'ruby start_queue.rb my_custom_url:my_custom_port'.

See the 'examples' folder for simple 'push' and 'pull' examples.

Note:

If the queue is empty, the returned message will be nil.

TODO:

Reasonable 'pull' polling.