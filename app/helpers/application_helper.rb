# encoding: utf-8
module ApplicationHelper
  
  def bt_login
    link_to "Facebook 登入", '/auth/facebook', :class => 'btn btn-primary'
  end
  
  def checkin_type_select(f, options = {})
    strs = []
    value = params[:check_type] || current_user.next_check_type
    Checkin::TYPES.each do |k,v|
      v += " "+content_tag(:span, "目標 #{options[:user].send("render_#{k}_target")}", :class => :label) if options[:user] && options[:user].respond_to?("#{k}_target") && options[:user].send("#{k}_target")
      str = content_tag :label, :class => :radio do
        opts = { :name => "#{f.object_name}[check_type]", :value => k, :type => :radio }
        opts[:checked] = :yes if k.to_sym == value.to_sym
        raw [tag(:input, opts), v].join
      end
      strs << str
    end
    raw strs.join("\n")
  end
  
  def code_font(text, opts = {})
    raw content_tag(:code, text)
  end
end
