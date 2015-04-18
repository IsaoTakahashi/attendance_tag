require 'sequel'
DB = Sequel.sqlite('db/attendance.sqlite')

def retrieve_attendance(id)
    attendances = DB[:attendances]
    attendance = attendances.where(:id => id).first
    return nil if attendance == nil

    attendance
end

def delete_attendance(id)
	attendance = retrieve_attendance(id)
	return false if attendance == nil

	attendances = DB[:attendances]
	attendances.where(:id => id).delete
	true
end 