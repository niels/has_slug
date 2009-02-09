# See the spec_helper for definition of controller & model classes
# as well as their setup
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


# Tests the check_slug! method
describe ApplicationController, 'check_slug!', :type => :controller do

  it "should raise a SlugMismatchError exception when a given id doesn't equal the complete slug of a model" do
    @invalid_ids.each do |id|
      lambda{controller.check_slug!(@slugged, id)}.should raise_error(SlugMismatchError, "Expected '#{@slugged.to_param}', got '#{id}'")
    end
  end

  it "should return true when confronted with an awesomely valid slug" do
    controller.check_slug!(@slugged, @valid_id).should be(true)
  end

end


# The following tests, while partially duplicating what has already been covered above, exist
# specifically to test the default rescue behaviour
describe SluggedController, 'default SlugMismatchError exception handling', :type => :controller do

  it "should redirect to model_name_url(model) upon invalid or incomplete id parameter" do
    # The controller is expected to redirect to its default path
    controller.should_receive(:slugged_url).exactly(@invalid_ids.size).times.with(@slugged).and_return("/correct")

    # This is necessary in at least rspec <= 1.1.11 to "unignore" rescue_handlers
    controller.use_rails_error_handling!

    # Run a request for each invalid id and confirm that we get redirected
    @invalid_ids.each do |id|
      get :show, :id => id
      response.should redirect_to("http://test.host/correct")
    end
  end

  it "should not redirect when provided with valid id" do
      get :show, :id => "12-test-umlauts-anyone-aou"
      response.should_not be_redirect
  end

end
