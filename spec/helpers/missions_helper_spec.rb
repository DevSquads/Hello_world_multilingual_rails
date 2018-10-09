require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MissionsHelper. For example:
#
# describe MissionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MissionsHelper, type: :helper do
  describe 'language form validation' do
    it "shouldn't create a language if no language entered " do
      reset_locale nil
      path = Rails.root.join('config', 'locales', ".yml")

      expect(File.exists?(path)).to eql(false)
    end
  end
end
