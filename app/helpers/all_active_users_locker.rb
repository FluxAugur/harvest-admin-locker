require "harvested"

Subdomain = 'synaptian'
Username = 'nate@synaptian.com'
Password = '!yzzorderrex76?'
Yesterday = Time.now - (60 * 60 * 24 * 11)    # 86,400 seconds = 1 day

def get_all_time_entries_from_yesterday_for_active_users
  harvest = Harvest.hardy_client(Subdomain, Username, Password)
  printer = "\n\n\t\t\tTime Entry Details for all Active Users for Yesterday\n"
  time_entries = []

  harvest.users.all.each { |user|
    printer += combine_first_and_last_names_for_user(user)+"\n" if user.is_active?
    harvest.time.all(Yesterday, user.id).each { |time_entry|
      time_entries.push(time_entry)
      printer += print_details_of_time_entry(time_entry)+"\n"
    }
  }
  puts printer
  return time_entries
end

def print_details_of_time_entry(t)
  "\t"+t.hours.to_s+"\t"+t.project+" - "+t.task+": "+t.notes
end

def combine_first_and_last_names_for_user(u)
  u.first_name+" "+u.last_name
end

def get_all_expenses_for_active_users_for_yesterday
  harvest = Harvest.hardy_client(Subdomain, Username, Password)
  printer = "\n\n\t\t\tExpenses for all Active Users for Yesterday\n"
  expenses = []

  harvest.users.all.each { |user|
    printer += combine_first_and_last_names_for_user(user)+"\n" if user.is_active?
    harvest.expenses.all(Yesterday, user.id).each { |expense|
      expenses.push(expense)
      printer += print_details_of_expense(expense)+"\n"
    }
  }
  puts printer
  return expenses
end

def print_details_of_expense(e)
  harvest = Harvest.hardy_client(Subdomain, Username, Password)
  "\t"+e.total_cost.to_s+"\t"+harvest.projects.find(e.project_id).name+" - "+harvest.expense_categories.find(e.expense_category_id).name+": "+e.notes
end

def create_dummy_invoice_to_lock_time_entries_and_expenses_for_yesterday(t, e)
  harvest = Harvest.hardy_client(Subdomain, Username, Password)
  active_projects = []
  harvest.projects.all.each { |project| active_projects.push(project) if project.active == true}
  puts active_projects
end

def process_yesterday
  time_entries_from_yesterday_for_active_users = get_all_time_entries_from_yesterday_for_active_users
  expenses_from_yesterday_for_active_users = get_all_expenses_for_active_users_for_yesterday
  create_dummy_invoice_to_lock_time_entries_and_expenses_for_yesterday(time_entries_from_yesterday_for_active_users, expenses_from_yesterday_for_active_users)
end

