require "spec_helper"

describe ShortUrl do
  let(:url) {"http://hehehehe.hehe/hehe/xixi"}
  let(:token) {"AaAaAa"}
  let(:su) {ShortUrl.parse(url)}

  subject {su}

  it {should be_valid}
  its(:long_url) {should eq url}
  its(:token) {should have(6).chars}
  specify {su;ShortUrl.parse(url).should eq su}
  specify do
    su1 = ShortUrl.create(long_url: "http://url1", token: token)
    su2 = ShortUrl.create(long_url: "http://url2", token: token)

    su1.token.should eq token
    su2.token.should_not eq token
    su2.should be_persisted
  end

  context "invalid url" do
    let(:url) {"xixi://balalalalala##qq.com"}

    it {should be_invalid}
  end
end
