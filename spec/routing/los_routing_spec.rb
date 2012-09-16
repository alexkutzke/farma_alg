require "spec_helper"

describe LosController do
  describe "routing" do

    it "routes to #index" do
      get("/los").should route_to("los#index")
    end

    it "routes to #new" do
      get("/los/new").should route_to("los#new")
    end

    it "routes to #show" do
      get("/los/1").should route_to("los#show", :id => "1")
    end

    it "routes to #edit" do
      get("/los/1/edit").should route_to("los#edit", :id => "1")
    end

    it "routes to #create" do
      post("/los").should route_to("los#create")
    end

    it "routes to #update" do
      put("/los/1").should route_to("los#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/los/1").should route_to("los#destroy", :id => "1")
    end

  end
end
