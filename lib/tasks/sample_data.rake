namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    create_users
    create_comps
    create_persons
    #create_relations
  end
end

def create_users
  User.create( email:"test@test.com", password: "test", password_confirmation: "test")
end

def create_comps
  Company.create(name: "Nodejitsu Inc.")
  Company.create(name: "Cubby Inc.")
end

def create_persons
  5.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    Person.create(firstname: name, email: email)
  end
end

def create_relations
  Person.all[2..4].each {|p| RelationPersonCompany.create(person_id: p.id, company_id: Company.first.id)}
end