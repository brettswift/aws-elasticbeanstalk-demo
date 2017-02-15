require 'sinatra'
require 'socket'

get '/' do
  hostname = Socket.gethostname
<<-TERMINATOR
  <h1>Welcome to beanstalk. <br><br></h1>

  <h3>You hit host: #{hostname}!</h3>

<i>
  This page is pretty useless in dev. But in prod it will provide evidence that the loadbalancer
  is functioning by showing you the IP of the webserver host.
</i>
<i> Version 2 </i>
TERMINATOR
end

get '/health' do
  status '200'
  body 'healthy'
end
