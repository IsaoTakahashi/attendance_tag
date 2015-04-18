require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sequel'
require 'date'
require 'haml'

require_relative 'models/init'

class Server < Sinatra::Base
    get '/' do
        DB = Sequel.sqlite('db/attendance.sqlite')
        employees = DB[:employees]
        @employees = employees.all

        attendances = DB[:attendances]
        @attendances = attendances.all
        p @employees
        haml :index
    end

    # drive servo
    get '/servo/:arg' do |arg|
        `echo 6=#{arg}% > /dev/servoblaster`
        'servo'
    end

    # CRUD employee
    post '/employee', provides: :json do
        body = request.body.read
        begin
            req_data = JSON.parse(body.to_s)
        rescue Exception => e
            p e
            status 400
            return
        end

        DB = Sequel.sqlite('db/attendance.sqlite')
        employees = DB[:employees]
        employees.insert(:name => req_data['name'],
                         :employee_number => req_data['employee_number'],
                         :team => req_data['team'],
                         :created_at => DateTime.now.to_s)

        status 201
    end

    get '/employee' do
        DB = Sequel.sqlite('db/attendance.sqlite')
        employees = DB[:employees]
        employees.all.to_s
    end

    get '/employee/:id' do |id|
        employee = retrieve_employee(id)
        if employee == nil then
            status 404
            return
        end

        employee.to_s
    end

    put '/employee/:id', provides: :json do |id|
        body = request.body.read
        begin
            req_data = JSON.parse(body.to_s)
        rescue Exception => e
            p e
            status 400
            return
        end

        employee = retrieve_employee(id)
        if employee == nil then
            status 404
            return
        end

        DB = Sequel.sqlite('db/attendance.sqlite')
        employees = DB[:employees]
        employees.where(:id => id).update(:name => req_data['name'],
                                        :employee_number => req_data['employee_number'],
                                        :team => req_data['team'],
                                        :updated_at => DateTime.now.to_s)

        status 200
    end

    delete '/employee/:id' do |id|
        result = delete_employee(id)
        if !result then
            status 404
            return
        end

        status 204
    end

    # CRUD attendance
    post '/attendance', provides: :json do
        body = request.body.read
        begin
            req_data = JSON.parse(body.to_s)
        rescue Exception => e
            p e
            status 400
            return
        end
        
        employee = retrieve_employee_by_name(req_data['employee_name'])
        registant = retrieve_employee_by_name(req_data['registant_name'])

        if employee == nil || registant == nil then
            status 400
            return
        end

        DB = Sequel.sqlite('db/attendance.sqlite')
        attendance = DB[:attendances]
        attendance.insert(:employee_id => employee[:id].to_i,
                         :registant_id => registant[:id].to_i,
                         :target_date => req_data['target_date'],
                         :status => req_data['status'],
                         :reason => req_data['reason'],
                         :from => req_data['from'],
                         :to => req_data['to'],
                         :comment => req_data['comment'],
                         :created_at => DateTime.now.to_s)
        status 201
    end

    get '/attendance' do
        DB = Sequel.sqlite('db/attendance.sqlite')
        attendance = DB[:attendances]
        attendance.all.to_s
    end

    get '/attendance/:id' do |id|
        attendance = retrieve_attendance(id)
        if attendance == nil then
            status 404
            return
        end

        attendance.to_s
    end

    get '/attendance/arrive/:employee_id' do |employee_id|
        dt = DateTime.now
        hour = dt.hour.to_s
        hour = '0' + hour if hour.length == 1
        min = dt.min.to_s
        min = '0' + min if min.length == 1
        dt_string = hour + ':' + min


        DB = Sequel.sqlite('db/attendance.sqlite')
        attendance = DB[:attendances]
        attendance.where(:employee_id => employee_id,:updated_at => nil)
        .update(:to => dt_string,
            :updated_at => dt.to_s)

        status 200
    end

    delete '/attendance/:id' do |id|
        result = delete_attendance(id)
        if !result then
            status 404
            return
        end

        status 204
    end


end
