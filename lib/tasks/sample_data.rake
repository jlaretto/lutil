namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    create_users
    create_comps
    create_persons
    create_test_data
    #create_relations
  end
end

def create_users
  User.create!( email:"test@test.com", password: "test", password_confirmation: "test")
end

def create_comps
  Company.create!(name: "Nodejitsu Inc.", street_address: "1234", city_state_zip: "New York", phone: "2124452323")
  Company.create!(name: "Cubby Inc.", street_address: "1234", city_state_zip: "New York", phone: "2124452323")

end

def create_persons
  5.times do |n|
    first_name  = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    street = Faker::Address.street_address
    city = "#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
    phone = Faker::PhoneNumber.phone_number

    Person.create!(first_name: first_name, last_name: last_name, email: email, street_address: street, city_state_zip: city, phone: phone )
  end
end

def create_relations
  Person.all[2..4].each {|p| RelationPersonCompany.create(person_id: p.id, company_id: Company.first.id)}
end

def create_test_data

  cmp =  Company.create!(name: "NewCo Inc.", street_address: "1234", city_state_zip: "New York", phone: "2124452323")

  usr = User.create!( email: "jeff@laretto.net", password: "test", password_confirmation: "test")

  p = Person.create!(first_name: "Jeff", last_name: "Laretto", email: "jeff@laretto.net", street_address: "1234", city_state_zip: "New York")

  usr.active_company = cmp
  usr.person = p
  usr.save!

  RelationPersonCompany.create!(person: p, company: cmp)

  arr_people = []

  3.times do |n|
    first_name  = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    street = Faker::Address.street_address
    city = "#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
    phone = Faker::PhoneNumber.phone_number


    pp = Person.create!(first_name: first_name, last_name: last_name, email: email, street_address: street, city_state_zip: city, phone: phone )
    RelationPersonCompany.create!(person: pp, company: cmp)

    arr_people.push(pp)
  end

    capTable = CapitalizationTable.new(description: "Actual", company: cmp)
    capTable.save!
    capRecord =  CapitalizationRecord.new(description: "Common Stock", authorized_amount: 10000000, capitalization_table: capTable)
    capRecord.save!
    eqPlan = EquityPlan.new(description: "2012 Equity Incentive Plan",authorized_amount: 10000, capitalization_record: capRecord )
    eqPlan.save!

    arr_people.each do |p|
      EquityRecord.create!(person: p, amount: 10000, equity_type: "Stock", capitalization_record: capRecord)
    end
    EquityRecord.create!(person: arr_people.first, amount: 1000, equity_type: "NSO Option", capitalization_record: capRecord, equity_plan: eqPlan)


end