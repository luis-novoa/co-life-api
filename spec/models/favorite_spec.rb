require 'rails_helper'
require 'spec_helper'

RSpec.describe Favorite, type: :model do
  subject { build(:favorite) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:home_id) }
  it { is_expected.to validate_presence_of(:user_home) }
  it { is_expected.to validate_uniqueness_of(:user_home).case_insensitive }
  it { is_expected.to_not allow_value("#{subject.home_id}_#{subject.user_id}").for(:user_home) }
  it { is_expected.to_not allow_value("#{Faker::Number.number}_#{Faker::Number.number}").for(:user_home) }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:home).required }
end
