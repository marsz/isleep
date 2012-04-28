module CheckinsHelper
  
  def checkins_dates(checkins)
    return [] if checkins.size == 0
    values = checkins.map(&:date)
    (values.min..values.max).map(&:to_s).reverse
  end
  
  def checkins_pick(checkins, opts = {})
    checkins.select{ |ck| ck.date.to_s == opts[:date].to_s && ck.check_type.to_sym == opts[:check_type].to_sym }
  end
  
  def checkins_pick_time(checkins, opts = {})
    ck = checkins.select{ |ck| ck.date.to_s == opts[:date].to_s && ck.check_type.to_sym == opts[:check_type].to_sym }.first || Checkin.new
    ck.created_at ? ck.created_at.strftime("%k:%M") : nil
  end
  
end
