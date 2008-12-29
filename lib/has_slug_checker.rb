# Provides some awesomity to add to your ActionControllers in order to ease the pain
# of validating permalinks.
# 
# To use it either rely on init.rb of the has_slug plugin or simply call
#   ActionController::Base.send(:include, HasSlugChecker)

module HasSlugChecker
  
  # Raises a SlugMismatchError when the given slug (or params[:id] if no slug is specified)
  # doesn't check out. This is tested by calling item.check_slug(slug).
  def check_slug!(item, slug = params[:id])
    item.check_slug(slug) ? true : (raise SlugMismatchError.new(item), "Expected '#{item.to_param}', got '#{slug}'")
  end
  
  def self.included(base) #:nodoc:
    base.class_eval do
      # Takes a block which is executed upon encountering a SlugMismatchError. The block may feast
      # on the passed exception to e.g. redirect to a URI containing the correct slug.
      def self.rescue_from_slug_mismatch(&rescuer)
        rescue_from "SlugMismatchError" do |exception|
          rescuer.bind(self).call(exception.item)
        end
      end
      
      rescue_from_slug_mismatch do |item|
        redirect_to(send("#{item.class.name.underscore}_url", item), :status => :moved_permanently)
      end
    end
  end
  
end