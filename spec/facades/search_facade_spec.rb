require 'rails_helper'

describe 'As a user' do
  describe 'The app knows if I already registered a location or not' do 
    it 'should return true if on i saved my location' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      json_response = File.read('spec/fixtures/location_search.json')

        stub_request(:get, "https://relocate-back-end-rails.herokuapp.com/api/v1/location/#{user.id}").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.3.0'
           }).
         to_return(status: 200, body: json_response, headers: {})

      facade = SearchFacade.location_exists(user.id)
     
      expect(facade).to be_a(Array)
      expect(facade[0]).to eq(true)
      expect(facade[1]).to eq("80110")
    end

    it 'should return false if i did not registered a location' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      json_response = File.read('spec/fixtures/location_search_null.json')

        stub_request(:get, "https://relocate-back-end-rails.herokuapp.com/api/v1/location/#{user.id}").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.3.0'
           }).
         to_return(status: 200, body: json_response, headers: {})

      facade = SearchFacade.location_exists(user.id)
      
      expect(facade).to be_a(Array)
      expect(facade[0]).to eq(false)
      expect(facade[1]).to eq(nil)
    end

    it "location should save and/or update" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      json_response = File.read('spec/fixtures/location_search.json')

      stub_request(:get, "https://relocate-back-end-rails.herokuapp.com/api/v1/location/#{user.id}").
       with(
         headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
         }).
       to_return(status: 200, body: json_response, headers: {})
       

      stub_request(:post, "https://relocate-back-end-rails.herokuapp.com/api/v1/80110/#{user.id}").
      with(
        headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Length'=>'0',
      'User-Agent'=>'Faraday v1.3.0'
        }).
      to_return(status: 200, body: json_response, headers: {})

      response = SearchFacade.save_address(user.id, 80110)
      saved_location = JSON.parse(response.body, symbolize_names: true)

     expect(saved_location).to be_a(Hash)
     expect(saved_location[:data]).to be_a(Hash)
     expect(saved_location[:data][:attributes]).to be_a(Hash)
     expect(saved_location[:data][:attributes][:user_id]).to be_a(Integer)
     expect(saved_location[:data][:attributes][:location]).to be_a(String)
     expect(saved_location[:data][:attributes][:location]).to eq("80110") 
    
     json_response = File.read('spec/fixtures/update_location.json')
     stub_request(:patch, "https://relocate-back-end-rails.herokuapp.com/api/v1/33179/#{user.id}").
       with(
         headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Content-Length'=>'0',
         'User-Agent'=>'Faraday v1.3.0'
         }).
       to_return(status: 200, body: json_response, headers: {})

     response = SearchFacade.update_address(user.id, 33179)
     saved_location = JSON.parse(response.body, symbolize_names: true)

     expect(saved_location[:data][:attributes][:location]).to eq("33179") 
    end

    it 'should delete location' do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      json_response = File.read('spec/fixtures/location_search.json')

      stub_request(:get, "https://relocate-back-end-rails.herokuapp.com/api/v1/location/#{user.id}").
       with(
         headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
         }).
       to_return(status: 200, body: json_response, headers: {})
       
       json_response = File.read('spec/fixtures/location_search_null.json')
       stub_request(:delete, "https://relocate-back-end-rails.herokuapp.com/api/v1/location/#{user.id}").
       with(
         headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'User-Agent'=>'Faraday v1.3.0'
         }).
       to_return(status: 200, body: json_response, headers: {})

      response = SearchFacade.destroy_address(user.id)
      
      deleted_location = JSON.parse(response.body, symbolize_names: true)
      expect(deleted_location[:data]).to eq(nil)
    end
  end
end