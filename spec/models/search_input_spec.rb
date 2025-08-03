require 'rails_helper'

RSpec.describe SearchInput, type: :model do
  it "is valid with valid attributes" do
    user = User.create(ip: "127.0.1")
    search = SearchInput.new(keyword: "hello", user: user)
    expect(search).to be_valid
  end

  it "is not valid without a keyword" do
    search = SearchInput.new(keyword: nil)
    expect(search).not_to be_valid
  end
end

