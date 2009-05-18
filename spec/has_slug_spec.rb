# encoding: utf-8

# See the spec_helper for definition of controller & model classes
# as well as their setup
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe Slugged, 'has_slug' do
  
  it "should have fantastic to_param output" do
    @slugged.to_param.should eql(@valid_id)
  end
  
  it "should be able to validate a given slug" do
    @invalid_ids.each { |id| @slugged.check_slug(id).should be(false) }
    @slugged.check_slug("12-test-umlauts-anyone-aou").should be(true)
  end

end