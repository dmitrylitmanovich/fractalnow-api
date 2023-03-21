require 'sinatra'
require 'dotenv'
require './src/services/create_fractal_service'

Dotenv.load

post '/fractal' do
	content_type 'application/octet-stream'

	config = request.body.read
	data = Services::CreateFractalService.new(config).call
	data
end
