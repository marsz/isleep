# encoding: utf-8
class Checkin < ActiveRecord::Base
  TYPES = { :sleep => '要睡覺', :wakeup => '剛起床' }
  TYPE_COLLECTION = TYPES.map
  
  belongs_to :user
  validates_presence_of :user_id
  validates_presence_of :check_type
  validates_presence_of :date
  validates_inclusion_of :check_type, :in => TYPES.keys.concat(TYPES.keys.map(&:to_s))

  before_validation :sync_date
  
  serialize :point_log, ActiveSupport::HashWithIndifferentAccess
  
  def self.human_attribute_name(attr, opts = {})
    attr.to_sym == :check_type ? '' : super
  end
  
  def time
    created_at.strftime("%k:%M")
  end
  
  private 
  
  def sync_date
    self.date = created_at.present? ? created_at.to_date : Date.today if new_record?
  end
  
  
end
