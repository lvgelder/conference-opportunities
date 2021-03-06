require 'rails_helper'

RSpec.describe ConferencesController do
  let(:twitter_handle) { "foobar" }

  describe "GET #show" do
    let!(:conference) do
      Conference.create(twitter_handle: twitter_handle, approved_at: approved_at, uid: "666")
    end
    let(:approved_at) { Time.now }

    context "when requested conference is approved" do
      specify do
        get :show, id: twitter_handle
        expect(response).to be_success
      end

      it "assigns the conference" do
        get :show, id: twitter_handle
        expect(assigns(:conference).instance).to eq(conference)
      end
    end

    context "when the conference is not approved" do
      let(:approved_at) { nil }

      it "redirects to the home page" do
        expect { get :show, id: twitter_handle }.
          to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when the requested conference doesn't exist" do
      it "raises a not found exception" do
        expect { get :show, id: "fake_twitter_handle" }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #index" do
    let!(:conference) do
      Conference.create(twitter_handle: twitter_handle, approved_at: Time.now, uid: "668")
    end

    let!(:unapproved_conference) do
      Conference.create(twitter_handle: 'grumpyconf', approved_at: nil, uid: "669")
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns all the approved conferences" do
      get :index
      expect(assigns(:conferences)).to eq([conference])
    end
  end
end
