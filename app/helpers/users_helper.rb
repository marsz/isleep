module UsersHelper
  def level(value)
    lv_exp(value)[0]
  end
  
  def current_exp(value)
    return 0 if value <= 0
    value % 100
  end
  
  def max_exp(value)
    lv_exp(value)[1]
  end
  
  private 
  
  def lv_exp(value)
    lv = 0
    base = 50
    return [1, base] if value <= 0
    exp = base
    while value > exp
      lv += 1
      exp = exp + (lv * base)
    end
    [lv + 1, exp]
  end
  
end
