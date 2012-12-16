namespace :db do
  namespace :seed do
    task :users => :environment do
      db_seed_users
    end
  end
end

def db_seed_users
  path=Rails.root.join('db', 'seeds', 'users.yml')
  puts "Seeding file #{path}"
  File.open(path) do |file|
    YAML.load_documents(file) do |doc|
      doc.keys.sort.each do |key|
        puts "Seeding key #{key}"
        attributes = doc[key]
        db_seed_user(attributes)
      end
    end
  end
end

def db_seed_user(attributes)
  first_name = attributes.fetch('first_name', '')
  last_name = attributes.fetch('last_name', '')
  wmata_key = attributes.fetch('wmata_key', '')
  email = attributes.fetch('email')
  password = attributes.fetch('password')
  User.delete_all("email in ('#{email}')")

  user = User.new(:first_name => first_name,
                  :last_name => last_name,
                  :wmata_key => wmata_key)
  user.password = password
  user.email = email
  user.skip_confirmation!
  if user.save
    puts "#{user.email} added"
  end
end
