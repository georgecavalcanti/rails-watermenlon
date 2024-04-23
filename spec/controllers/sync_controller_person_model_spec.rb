require 'rails_helper'
require 'api_helper'
RSpec.describe SyncController, type: :controller do
  describe 'push changes for people', type: :request do
    let!(:person) { FactoryBot.create(:person) }
    let!(:params_created_and_updated) {
      {
        "lastPulledAt": "1600987448734",
        "changes": {
          "people": {
            "created": [
              {
                "id": SecureRandom.uuid,
                "name": Faker::Name.name
              }
            ],
            "updated": [
              {
                "id": person.id,
                "name": Faker::Name.name
              }
            ],
            "deleted": []
          }
        }
      }
    }

    let!(:params_only_created)  {
      {
        "lastPulledAt": "1600987448734",
        "changes": {
          "people": {
            "created": [
              {
                "id": SecureRandom.uuid,
                "name": Faker::Name.name
              }
            ],
            "updated": [],
            "deleted": []
          }
        }
      }
    }


    it 'is valid with status code 200' do
      post '/sync_push', params: params_created_and_updated
      
      expect(response).to have_http_status(:success)
    end

    # it 'is not valid without changes objects and lastPulledAt' do
    #   post '/api/v1/sync_push', params: {}
    #   expect(response).to have_http_status(:internal_server_error)
    # end
  end
end
