require 'sinatra'
require 'sinatra/reloader'
require 'json'

class Server < Sinatra::Base
    get '/' do
        'Interactive 勤怠 Sytem!'
    end

    get '/attendance' do
        # display attendance information
        'Under Construction'
    end

    get '/servo/:arg' do |arg|
    	rad = arg || '0'
    	`echo 6=#{arg}% > /dev/servoblaster`
	'servo'
    end

    post '/register', provides: :json do
        body = request.body.read
        p body
        begin
            req_data = JSON.parse(body.to_s)
        rescue Exception => e
            p e
            status 400
        end
        `date`
    end
end
