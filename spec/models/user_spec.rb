require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  subject { build(:user) } 

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value("email@test.com").for(:email) } 
  it { is_expected.to_not allow_value("emailtest.com").for(:email) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(50) }

  it { is_expected.to validate_presence_of(:password_confirmation) }

  it ".admin default to false" do
    subject.save
    expect(subject.admin).to eq(false) 
  end
end
