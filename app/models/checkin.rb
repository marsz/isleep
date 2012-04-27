# encoding: utf-8
class Checkin < ActiveRecord::Base
  TYPES = { :wakeup => '起床', :sleep => '睡覺' }
  TYPE_COLLECTION = TYPES.map
  
  belongs_to :user
  validates_presence_of :user_id
  validates_presence_of :check_type
  validates_presence_of :date
  validates_inclusion_of :check_type, :in => TYPES.keys.concat(TYPES.keys.map(&:to_s))
  validates_uniqueness_of :check_type, :scope => [:user_id, :date]

  before_validation :sync_date
  
  def self.human_attribute_name(attr, opts = {})
    attr.to_sym == :check_type ? '' : super
  end
  
  private 
  
  def sync_date
    self.date = created_at.present? ? created_at.to_date : Date.today if new_record?
  end
  
  
end
