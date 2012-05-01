class PointObserver < ActiveRecord::Observer
  observe :checkin
  
  def after_create(checkin)
    count_sp checkin
    count_hp checkin
  end
  
  private
  
  def count_sp(checkin)
    if checkin.check_type.to_s == 'sleep'
      offset = count_point_offset(checkin.created_at, checkin.user.sleep_target, 3, -8)
      User.update_counters checkin.user_id, :sp => offset if offset != 0
    end
  end

  def count_hp(checkin)
    if checkin.check_type.to_s == 'wakeup'
      offset = count_point_offset(checkin.created_at, checkin.user.wakeup_target, 5, -10, :bias_early => 3.hours, :bias_late => 0.5.hours)
      User.update_counters checkin.user_id, :hp => offset if offset != 0
    end
  end
  
  def count_point_offset(created_at, target_time, max_plus, max_minus, opts = {})
    return 0 unless target_time
    opts[:bias_early] ||= 1.hour
    opts[:bias_late] ||= 1.hour
    target = target_time.change :year => created_at.year, :month => created_at.month, :day => created_at.day
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
