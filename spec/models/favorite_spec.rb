require 'rails_helper'
require 'spec_helper'

RSpec.describe Favorite, type: :model do
  subject { build(:favorite) } 
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:home_id) }
  it { is_expected.to belong_to(:user).required }
end
