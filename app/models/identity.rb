class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  serialize :auth_data, JSON

  def auth
    Hashie::Mash.new auth_data
  end

  %w(name email image).each do |attr|
    define_method attr do
      auth.info.send(attr) || fail('Could not find #{attr} in #{auth}')
    end
  end
end
