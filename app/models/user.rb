class User < ActiveRecord::Base
    has_many :search_inputs, dependent: :destroy
    validates :ip, presence: true, uniqueness: true

    def self.find_or_create_by_ip(ip)
        find_or_create_by(ip: ip[:ip])
    end
end