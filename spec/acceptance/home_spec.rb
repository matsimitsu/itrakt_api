require File.dirname(__FILE__) + '/acceptance_helper'

feature "Home" do

  context "locale and currency" do

    scenario "dutch visitor" do
      ApplicationController.stub!(:country).and_return('nl')

      visit homepage

      current_path.should == homepage('nl')
      page.should have_content 'Hoe werkt het?'
      page.should have_content 'Vanaf € 250,-'
    end

    scenario "dutch visitor navigates to the english locale and back" do
      ApplicationController.stub!(:country).and_return('nl')

      visit homepage

      click_link_or_button 'English'

      current_path.should == homepage('en')
      page.should have_content 'From € 250,-'

      click_link_or_button 'Nederlands'

      current_path.should == homepage('nl')
      page.should have_content 'Vanaf € 250,-'
    end

    scenario "german visitor" do
      ApplicationController.stub!(:country).and_return('de')

      visit homepage

      current_path.should == homepage('en')
      page.should have_content 'From € 250,-'
    end

    scenario "german visitor that selects the dutch locale" do
      ApplicationController.stub!(:country).and_return('de')

      visit homepage('nl')

      current_path.should == homepage('nl')
      page.should have_content 'Vanaf € 250,-'
    end

    scenario "american visitor" do
      ApplicationController.stub!(:country).and_return('us')

      visit homepage

      current_path.should == homepage('en')
      page.should have_content 'From $350'
    end

    scenario "canadian visitor" do
      ApplicationController.stub!(:country).and_return('us')

      visit homepage

      current_path.should == homepage('en')
      page.should have_content 'From $350'
    end

  end

end
