require "spec_helper"
require "pry"

describe ShortUrlApp do
  let(:long) {"http://www.baidu.com"}
  let(:su)   {ShortUrl.parse long}

  describe "POST /parse" do
    it "returns a generated short url" do
      post "/parse", long_url: long

      last_response.body.should match ShortUrl::SHORT_URL_REGEX
      ShortUrl.parse(last_response.body).long_url.should eq long 
    end
  end

  describe "GET /:token" do
    it "redirects to long url" do
      get "/#{su.token}"

      last_response.should be_redirect
      last_response.location.should eq long
    end
    
    it "returns 404" do
      get "/blabla"
      
      last_response.status.should be 404
    end
  end
end
