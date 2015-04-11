# Admin
admin1 = Admin.find_or_initialize_by(email: "pierre@hipcamp.com")
admin1.update_attributes(password: "cherryblossom") if admin1.new_record?
admin2 = Admin.find_or_initialize_by(email: "julian@hipcamp.com")
admin2.update_attributes(password: "cherryblossom") if admin2.new_record?