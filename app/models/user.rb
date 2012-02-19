# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation


  email_regex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates :name, :presence => true,
                   :length   => { :maximum => 50 } 
           
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false } 

  # Automatically create the virtual attribute 'password_confirmation.'
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password

  # Return true if the user's password matches the submitted password
  def has_password?(submitted_password)
    # compare encrypted_password with an encrypted version of submitted_password
    encrypted_password == encrypt( submitted_password )
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash( "#{salt}--#{string}" )
    end

    def make_salt
      secure_hash( "#{Time.now.utc}--#{password}" )
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end


end


