require 'rails_helper'

RSpec.describe "Posts", type: :request do

    #Describe es autodocumentación para el desarrollador.
    describe "GET /post" do
        before { get '/posts' }

        #El codigo que se retorne debe ser 200
        it "should return OK" do
            payload = JSON.parse( response.body )
            expect( payload ).to be_empty
            expect( response ).to have_http_status(200)
            
        end
    end


    describe "with data in the DB" do
        #Sin el ! en el metodo let, los objetos se crean cuando se necesiten, con el ! se crean de manera prematura.
        let!(:posts) { create_list(:post, 10 , published: true ) }
        it "should return all the published posts" do
            get '/posts' 
            payload = JSON.parse( response.body )
            expect( payload.size ).to eq( posts.size )
            expect( response ).to have_http_status(200)    
        end
    end


    describe "GET /posts/{id}" do
        let!(:post) { create( :post ) }
        
            it "should return a post" do
                get "/posts/#{post.id}" 
                payload = JSON.parse( response.body )
                expect( payload ).not_to be_empty
                expect( payload["id"] ).to eq( post.id )
                expect( payload["title"] ).to eq( post.title )
                expect( payload["content"] ).to eq( post.content )
                expect( payload["published"] ).to eq( post.published )
                expect( payload["author"]["name"] ).to eq( post.user.name )
                expect( payload["author"]["email"] ).to eq( post.user.email )
                expect( payload["author"]["id"] ).to eq( post.user.id )
                expect( response ).to have_http_status(200) 
        end
    end

    describe "POST /posts" do
        let!( :user ) { create( :user ) }

        it "sholud create a post" do
            req_payload = {
                post: {
                    title: "titulo",
                    content: "contenido",      
                    published: false,
                    user_id: user.id          
                }
            }
        #POST HTTP
        post "/posts", params: req_payload
        payload = JSON.parse( response.body )
        expect( payload ).not_to be_empty
        expect( payload['id'] ).not_to be_nil
        expect( response ).to have_http_status( :created )
        end

        it "sholud return error message on invalid post" do
            req_payload = {
                post: {
                    content: "contenido",      
                    published: false,
                    user_id: user.id          
                }
            }
        #POST HTTP
        post "/posts", params: req_payload
        payload = JSON.parse( response.body )
        expect( payload ).not_to be_empty
        expect( payload["error"] ).not_to be_empty
        expect( response ).to have_http_status( :unprocessable_entity )
        end

    end

    describe "PUT /posts/{id}" do
        let!( :article ) { create( :post ) }

        it "sholud be updated a post" do
            req_payload = {
                post: {
                    title: "titulo actualizado",
                    content: "contenido actualizado",      
                    published: true,
                              
                }
            }
        #PUT HTTP
        put "/posts/#{article.id}", params: req_payload
        payload = JSON.parse( response.body )
        expect( payload ).not_to be_empty
        expect( payload["id"] ).to eq( article.id )
        expect( response ).to have_http_status( :ok )
        end

        it "sholud return error message on invalid put" do
            req_payload = {
                post: {
                    title: nil,
                    content: nil,      
                    published: false,        
                }
            }
        #PUT HTTP
        put "/posts/#{article.id}", params: req_payload
        payload = JSON.parse( response.body )
        expect( payload ).not_to be_empty
        expect( payload['error'] ).not_to be_empty
        expect( response ).to have_http_status( :unprocessable_entity )
        end
    end

end