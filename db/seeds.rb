puts "Seeding\n============="

puts "\nUser Accounts\n-------------"


User.delete_all("email in ('hodnettg@gmail.com')")

seed_user = User.new(:first_name => 'Grayson', 
                     :last_name => 'Hodnett', 
                     :wmata_key => 'cyvxyeaahwd29ua2u9phkph8')
seed_user.password = 'secret'
seed_user.email = 'hodnettg@gmail.com'
seed_user.skip_confirmation!
if seed_user.save
  puts "#{seed_user.email} added"
end
