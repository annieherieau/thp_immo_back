# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
Faker::Config.locale='fr'
Faker::UniqueGenerator.clear

# Supprimer toutes les données existantes
def reset_db
  User.destroy_all
  City.destroy_all

  # reset table sequence
  ActiveRecord::Base.connection.tables.each do |t|
    # postgreSql
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
    # SQLite
    # ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = '#{t}'")
  end

  puts('drop and reset all tables')
end

def create_users(number)
  number.times do |i|
    User.create!(
      email: Faker::Internet.unique.email,
      password: '123456'
    )
  end
  puts("#{number} Users créés")
end

def create_cities(number)
  number.times do |i|
    City.create!(
      name: Faker::Address.unique.city,
    )
  end
  puts("#{number} Cities créés")
end

def create_listings(number)
  number.times do |i|
    Listing.create!(
      user: User.all.sample,
      city: City.all.sample,
      title: Faker::Books::Dune.planet,
      description: Faker::Books::Dune.quote,
      price: Faker::Number.within(range: 100..1000)
    )
  end
  puts("#{number} Listings créés")
end

# PERFORM SEEDING
reset_db
create_users(10)
create_cities(5)
create_listings(30)

