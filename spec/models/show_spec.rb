require 'spec_helper'

describe Show do

  it "should have a valid blueprint" do
    show = Show.make
    show.should be_valid
  end


end
