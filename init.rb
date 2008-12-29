require 'has_slug'

ActiveRecord::Base.send :include, ActiveRecord::Has::Slug
ActionController::Base.send(:include, HasSlugChecker)
