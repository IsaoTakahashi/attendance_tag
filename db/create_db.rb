require 'sequel'

DB = Sequel.sqlite('attendance.sqlite')

DB.create_table :employees do
    primary_key :id
    String :name
    Integer :employee_number
    String :team
    String :created_at
    String :updated_at
end

DB.create_table :attendances do
	primary_key :id
	Integer :employee_id
	Integer :registant_id
	String :target_date
	String :status
	String :reason
	String :from
	String :to
	String :comment
	String :created_at
	String :updated_at
end
