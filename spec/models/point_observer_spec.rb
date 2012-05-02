require 'spec_helper'

describe PointObserver do
  
  before do
    @user = FactoryGirl.create :user, :sleep_target => '00:00', :wakeup_target => '07:00'
    @user.reload
    @time = Time.zone.parse(Date.today.to_s+" "+@user.sleep_target.to_s[11..15])
  end
  
  describe "sleep" do
    it "minus" do
      check = @user.checkins.create(:check_type => :sleep, :created_at => @time-5.hour)
      @user.reload
      @user.sp.should == -8
      check.destroy
      @user.reload
      @user.sp.should == 0
    end
  
    it "plus" do
      check = @user.checkins.create(:check_type => :sleep, :created_at => @time+0.5.hour)
      @user.reload
      @user.sp.should == 3
      check.destroy
      @user.reload
      @user.sp.should == 0
    end
  end

  describe "wakeup" do
    before do
      @wakeup_time = @time + 7.hours
    end
  
    it "minus" do
      check1 = @user.checkins.create(:check_type => :wakeup, :created_at => @wakeup_time + 2.hours)
      @user.reload
      @user.hp.should == -3

      check2 = @user.checkins.create(:check_type => :wakeup, :created_at => @wakeup_time - 5.hours)
      @user.reload
      @user.hp.should == -7

      check1.destroy
      check2.destroy
      @user.reload
      @user.hp.should == 0
    end
  
    it "plus" do
      check = @user.checkins.create(:check_type => :wakeup, :created_at => @wakeup_time - 2.hours)
      @user.reload
      @user.hp.should == 5

      check.destroy
      @user.reload
      @user.hp.should == 0
    end
  end

end
