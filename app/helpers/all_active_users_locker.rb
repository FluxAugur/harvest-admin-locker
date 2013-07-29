require "harvested"

Subdomain = 'synaptian'
Username = 'nate@synaptian.com'
Password = '!yzzorderrex76?'

def get_all_time_entries_for_active_users_for_yesterday
  harvest = Harvest.hardy_client(Subdomain, Username, Password)
  yesterday = Time.now - (60 * 60 * 24)    # 86,400 seconds = 1 day
  printer = "\n\n\t\t\tTime Entry Details for all Active Users for Yesterday\n"
  harvest.users.all.each { |user| printer += user.is_active? ? combine_first_and_last_names_for_user(user)+"\n" : notify_inactive_status_of_user(user)
    harvest.time.all(yesterday, user.id).each { |time_entry| printer += print_details_of_time_entry(time_entry)+"\n" }
  }
  puts printer
end

def print_details_of_time_entry(t)
puts "*******************************"
puts t
puts "*******************************"

  "\t"+t.hours.to_s+"\t"+t.project+" - "+t.task+": "+t.notes
end

def notify_inactive_status_of_user(u)
  ""
  # "***** No active user named "+combine_first_and_last_names_for_user(u)
end

def notify_zero_time_entered_for_user(u)
  ""
  # "\tZero time entered for "+combine_first_and_last_names_for_user(u)
end

def combine_first_and_last_names_for_user(u)
  u.first_name+" "+u.last_name
end

get_all_time_entries_for_active_users_for_yesterday
