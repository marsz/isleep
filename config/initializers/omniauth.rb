Rails.application.config.middleware.use OmniAuth::Builder do
  $FB_Config = ActiveSupport::HashWithIndifferentAccess.new(YAML.load(File.open("#{Rails.root}/config/facebook.yml"))[Rails.env])
  perms = 'email,offline_access,user_location'
  provider :facebook, $FB_Config[:app_id], $FB_Config[:api_secret], :scope => perms
end