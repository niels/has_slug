# Slurp in the full Rails stack
# Takes some time but makes it easier to write the tests..
# TODO This is temporary, we actually don't want to load the user defined classes
require File.dirname(__FILE__) + '/../../../../config/environment.rb'
require 'spec/rails'

# Of course we don't want to create a database and such so we're mocking out AR
# Also see http://blog.s21g.com/articles/472
class MockBase < ActiveRecord::Base; end
MockBase.class_eval do
  alias_method :save, :valid?
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
  end
end


class Slugged < MockBase
  column :id, :integer
  column :category, :string
  column :title, :string
  
  has_slug(:category, :title)
end


class SluggedController < ApplicationController
  cattr_accessor :slugged
  
  def show
    check_slug!(@@slugged)
  end
end

class CustomSluggedController < SluggedController
  rescue_from_slug_mismatch do
    redirect_to "/somewhere-custom"
  end
end


# Shared setup procedure for all describe blocks
Spec::Runner.configure do |config|
  config.before(:each) do
    @slugged = Slugged.new(:category => "Test", :title => "Umlauts anyone? => äöü")
    @slugged.id = 12 # can't set this in .new as it would normally be auto-assigned
    
    SluggedController.slugged = @slugged # feed the controller a model
    
    @valid_id = "12-test-umlauts-anyone-aou" # as we defined a slug as consisting of :category and :title
    @invalid_ids = %w(12 12-test 12-umlauts-anyone-aou random)
  end
end