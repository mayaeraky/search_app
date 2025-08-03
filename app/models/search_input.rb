class SearchInput < ActiveRecord::Base
    belongs_to :user
    validates :keyword, presence: true
end