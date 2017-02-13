require 'sinatra'
require 'socket'

get '/' do
  hostname = Socket.gethostname
<<-TERMINATOR
  <h1>Welcome to beanstalk. <br><br></h1>

  You hit host: #{hostname}!
TERMINATOR
end

get '/health' do
  status '200'
  body 'healthy'
end
