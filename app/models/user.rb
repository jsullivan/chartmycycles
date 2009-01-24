require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false
  before_save :encrypt_password
  has_one :avatar
  has_many :cycles
  has_many :entries
  has_many :forums
  has_many :posts
  has_one :about
  has_many :comments
  has_one :subscription_info
  belongs_to :charting_for
  
  # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find_by_email(email) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def name
    if self.first_name && self.first_name.length > 1
      return self.first_name
    else 
      return self.email
    end
  end
  
  def full_name
     if self.first_name && self.first_name.length > 1 && self.last_name && self.last_name.length > 1
       return (self.first_name + ' ' + self.last_name)
     else 
       return self.email
     end
   end
  
  def display_motto
    if self.motto && self.motto.length > 1
      return self.motto
    else
      return "You haven't set your status. Click edit to create a new one."
    end
  end

  def current_cycle
    current_cycle = self.cycles.find(:first, :conditions => 'current = true')
    return current_cycle
  end
  
  def cycle_start_date
    start_date = self.current_cycle.started
    days = (start_date - 1.day)
    return days
  end
  
  def cycle_day_count
    count = (Time.now.to_date - self.current_cycle.started.to_date).to_i
    if count <= 30
      return 30
    else
      return count
    end
    end
  
  def entries
    current_cycle = self.current_cycle
    entries = current_cycle.entries    
  end
  
  def last_cycle
  @old_cycles  = self.cycles.find(:all, :conditions => 'current = false', :order => 'created_at ASC')
  if @old_cycles.length >= 1
  cycle_array = Array.new
  for cycle in @old_cycles
    cycle_array << cycle.id
  end
  id = cycle_array.last
  @last_cycle = Cycle.find(id)
  return @last_cycle
  end
  end
 
  def member_check
    if self.member?
      return "member"
    else
      return "guest"
    end
  end
  
  def user_since
   if self.member? 
     return self.member_start_date
   else
     return self.created_at
   end
  end
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end

end
