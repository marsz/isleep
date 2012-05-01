require 'spec_helper'

describe PointObserver do
  
  before do
    @user = FactoryGirl.create :user, :sleep_target => Time.now.beginning_of_day, :wakeup_target => Time.now.beginning_of_day+7.hours
    @time = @user.sleep_target
  end
  
  describe "sleep" do
    it "minus" do
      checks = @user.checkins.create(:check_type => :sleep, :created_at => @time-5.hour)
      @user.reload
      @user.sp.should == -8
    end
  
    it "plus" do
      checks = @user.checkins.create(:check_type => :sleep, :created_at => @time+0.5.hour)
      @user.reload
      @user.sp.should == 3
    end
  end

  describe "wakeup" do
    before do
      @wakeup_time = @time + 7.hours
    end
  
    it "minus" do
      checks = @user.checkins.create(:check_type => :wakeup, :created_at => @wakeup_time + 2.hours)
      @user.reload
      @user.hp.should == -2

      checks = @user.checkins.create(:check_type => :wakeup, :created_at => @wakeup_time - 5.hours)
      @user.reload
      @user.hp.should == -6
    end
  
    it "plus" do
      checks = @user.checkins.create(:check_type => :wakeup, :created_at => @wakeup_time - 2.hours)
      @user.reload
      @user.hp.should == 5
    end
  end

end
