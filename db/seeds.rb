
%w(cedric.nehemie johan.van.ryseghem thomas.franco frederic.thibault).each do |k|
  u = User.create! do |s|
    s.email = "#{k}@agence3print.fr"
    s.password = ENV['DEFAULT_PASSWORD']
    s.password_confirmation = ENV['DEFAULT_PASSWORD']
    s.first_name = k.split('.').first.capitalize
    s.last_name = k.split('.').last.capitalize
    s.role = :admin
  end

  p "User #{u.email} created"
end
