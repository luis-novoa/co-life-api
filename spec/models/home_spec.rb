require 'rails_helper'
require 'spec_helper'

RSpec.describe Home, type: :model do
  subject { build(:home) } 
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(3).is_at_most(100) }

  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_uniqueness_of(:address).case_insensitive }
  it { is_expected.to validate_length_of(:address).is_at_least(3).is_at_most(100) }

  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_length_of(:city).is_at_least(3).is_at_most(50) }

  it { is_expected.to validate_presence_of(:country) }
  it { is_expected.to validate_length_of(:country).is_at_least(3).is_at_most(20) }

  it { is_expected.to validate_presence_of(:rent) }
  it { is_expected.to validate_numericality_of(:rent) }

  it { is_expected.to validate_presence_of(:room_type) }
  it { is_expected.to validate_inclusion_of(:room_type).in_array(%w(individual shared)) }

  it { is_expected.to validate_length_of(:more_info).is_at_least(0).is_at_most(500) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to belong_to(:user).required } 
end
