HP_BIAS_EARLY = 3
HP_BIAS_LATE = 0.5
HP_MAX_INCREASE = 5
HP_MAX_DECREASE = -10
SP_BIAS_EARLY = 1
SP_BIAS_LATE = 1
SP_MAX_INCREASE = 3
SP_MAX_DECREASE = -8
class PointObserver < ActiveRecord::Observer
  observe :checkin
  
  def after_create(checkin)
    count_sp checkin
    count_hp checkin
  end
  
  def after_destroy(checkin)
    rollback_point checkin
  end
  
  private
  
  def rollback_point(checkin)
    if checkin.point_log.key?(:offset)
      offset = checkin.point_log[:offset]
      col = { :sleep => :sp, :wakeup => :hp }[checkin.check_type.to_sym]
      User.update_counters checkin.user_id, col => offset * -1
    end
  end
  
  def count_sp(checkin)
    if checkin.check_type.to_s == 'sleep'
      offset = count_point_offset(checkin.created_at, checkin.user.sleep_target, SP_MAX_INCREASE, SP_MAX_DECREASE, :bias_early => SP_BIAS_EARLY.hours, :bias_late => SP_BIAS_LATE.hours)
      if offset != 0
        User.update_counters checkin.user_id, :sp => offset 
        point_log = { :target => checkin.user.sleep_target, :offset => offset }
        checkin.update_attribute :point_log, point_log
      end
    end
  end

  def count_hp(checkin)
    if checkin.check_type.to_s == 'wakeup'
      offset = count_point_offset(checkin.created_at, checkin.user.wakeup_target, HP_MAX_INCREASE, HP_MAX_DECREASE, :bias_early => HP_BIAS_EARLY.hours, :bias_late => HP_BIAS_LATE.hours)
      if offset != 0
        User.update_counters checkin.user_id, :hp => offset 
        point_log = { :target => checkin.user.wakeup_target, :offset => offset }
        checkin.update_attribute :point_log, point_log
      end
    end
  end
  
  def count_point_offset(created_at, target_time, max_plus, max_minus, opts = {})
    return 0 unless target_time
    opts[:bias_early] ||= 1.hour
    opts[:bias_late] ||= 1.hour
    target = Time.zone.parse(target_time.to_s[11..15]).change :year => created_at.year, :month => created_at.month, :day => created_at.day
    target = target + 1.day if target - created_at < -12.hours
    target = target - 1.day if target - created_at > 12.hours
    from = target - opts[:bias_early]
    to = target + opts[:bias_late]
    if (from.to_i..to.to_i).include?(created_at.to_i)
      offset = max_plus
    elsif created_at < from
      offset = -1 * ((from - created_at) / 30.minutes).to_i
    else
      offset = -1 * ((created_at - to) / 30.minutes).to_i
    end
    offset = max_minus if offset < max_minus
    offset
  end

end
