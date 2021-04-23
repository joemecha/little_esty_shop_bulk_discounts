require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end
  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many(:merchants).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'instance methods' do
    it "::full_name" do
      @customer_1 = create(:customer, first_name: 'Baxter', last_name: 'Brick')
      expect(@customer_1.full_name).to eq('Baxter Brick')
    end
  end
end
