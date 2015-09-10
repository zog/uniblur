
%w(reuno@reuno.net johan@about-blank.fr).each do |k|
  u = User.create! do |s|
    s.email = k
    s.password = ENV['DEFAULT_PASSWORD']
    s.password_confirmation = ENV['DEFAULT_PASSWORD']
    s.first_name = k.split('@').first.capitalize
    s.last_name = k.split('@').first.capitalize
    s.role = :admin
  end

  p "User #{u.email} created"
end
