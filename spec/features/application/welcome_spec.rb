require 'rails_helper'

RSpec.describe 'welcome page' do
  context 'you go to the main page' do
    it 'displays a title' do
      visit '/'

      expect(page).to have_content('Now with BULK DISCOUNTS!')
    end
  end
end
