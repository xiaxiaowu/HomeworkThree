require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

 #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    Customer.where(first: 'Candice')
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
  end
  def self.with_valid_email
    Customer.where("email like '%@%'")
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
  end
  # etc. - see README.md for more details

  def self.with_dot_org_email
    Customer.where("email like '%.org'")
  end

  def self.with_invalid_email
    Customer.where("email not like '%@%'")
  end

  def self.with_blank_email
    # Customer.where(email: nil)
    Customer.where('email is null')
  end

  def self.born_before_1980
    Customer.where("birthdate < '1980-01-01 00:00:00'")
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("email like '%@%' and birthdate < '1980-01-01 00:00:00' ")
  end

  def self.last_names_starting_with_b
    # Customer.where("last like 'B%'").order(:birthdate)
    # Customer.where("last like 'B%'").order('birthdate')
    Customer.where("last like 'B%'").order('birthdate asc')

  end

  def self.twenty_youngest
    Customer.all.order(:birthdate).limit(20)
    # order by birthdate asc limit 20
  end

  def self.update_gussie_murray_birthdate
    Customer.find_by(first: 'Gussie', last: 'Murray').update(birthdate: Time.find_zone("UTC").parse('2004-02-08'))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'").update_all(email: '123@qq.com')
    # Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'").each do |c|
    #   c.update(email: "123@qq.com")
    # end
  end

  def self.delete_meggie_herman
    Customer.find_by(:first => 'Meggie', :last => 'Herman').destroy
  end

  def self.delete_everyone_born_before_1978
    Customer.where("birthdate < '1978-01-01'").delete_all
    # Customer.where("birthdate < '1978-01-01'").each do |c|
    #   c.destroy
    # end
    # Customer.where("birthdate <= '1977-12-31'")
  end
end
