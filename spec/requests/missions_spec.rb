require 'rails_helper'

RSpec.describe "Missions", type: :request do
  describe "GET /missions" do
    it 'exists!' do
      get missions_path
      expect(response).to have_http_status(200)
    end
  end
end
