require 'rails_helper'

RSpec.describe "Posts", type: :request do

    #Describe es autodocumentación para el desarrollador.
    describe "GET /health" do
        before { get '/health' }

        #El codigo que se retorne debe ser 200
        it "should return OK" do

            payload = JSON.parse( response.body )
            expect( payload ).not_to be_empty
            expect( payload['api'] ).to eq( 'OK' )
        end

        it "should return status code 200" do
            expect( response ).to have_http_status(200)     
        end

    end
    
end