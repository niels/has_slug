# encoding: utf-8

# Provides an ActiveRecord to provide the has_slug function with which even a
# squirrel could easily slugalize all its models.
#
# To use it either rely on init.rb of the has_slug plugin or simply call
#   ActiveRecord::Base.send :include, ActiveRecord::Has::Slug

module ActiveRecord #:nodoc:
  module Has #:nodoc:
    module Slug #:nodoc:
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        
        # has_slug takes an arbitrary number of Symbols as arguments. Those
        # should be methods (i.e. ActiveRecord attributes) of your model which
        # return strings to be slugalized.
        # E.g. has_slug(:title)
        # or   has_slug(:category, :short_title)
        def has_slug(*parts)
          # Ouch, that's not pretty! Any beautification ideas?
          self.class_eval <<-EOR
            def to_param
              p = self.id.to_s
              #{parts.collect { |part| 'p += "-#{(self.' + part.to_s + ').parameterize}" unless self.' + part.to_s + '.blank?'+"\n"}}
              p
            end

            # Checks if a given string equals self.to_param
            def check_slug(slug)
              slug == self.to_param
            end
          EOR
        end
      end
    end
  end
end

