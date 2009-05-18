# encoding: utf-8

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
      # By default we permanently redirect to model_url(model) upon encountering a SlugMismatchError
      rescue_from SlugMismatchError do |exception|
        redirect_to(send("#{exception.item.class.name.underscore}_url", exception.item), :status => :moved_permanently)
      end
    end
  end
  
end