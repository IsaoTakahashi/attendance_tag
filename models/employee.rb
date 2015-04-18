require 'sequel'
DB = Sequel.sqlite('db/attendance.sqlite')

def retrieve_employee(id)
    employees = DB[:employees]
    employee = employees.where(:id => id).first
    return nil if employee == nil

    employee
end

def retrieve_employee_by_name(name)
	employees = DB[:employees]
    employee = employees.where(:name => name).first
    return nil if employee == nil

    employee
end

def delete_employee(id)
	employee = retrieve_employee(id)
	return false if employee == nil

	employees = DB[:employees]
	employees.where(:id => id).delete
	true
end 