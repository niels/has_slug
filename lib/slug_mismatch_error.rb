# encoding: utf-8

# The exception raised by ApplicationController::Base.check_slug! when encountering a
# slug mismatch. Holds the AR instance the slug has been compared to and makes it 
# available as @item
class SlugMismatchError < ArgumentError
  attr_reader :item
  def initialize(item) #:nodoc:
    @item = item
  end
end
