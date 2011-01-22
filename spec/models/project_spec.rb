require 'spec_helper'

describe Project do

  it "should have a valid blueprint" do
    Project.make
  end

  it "should validate the name and e-mail address" do
    project = Project.new
    project.save

    project.should_not be_valid
    project.errors[:client_name].should have(1).item
    project.errors[:email].should have(1).item
  end

  it "should deliver a new project mail after create" do
    proc {
      Project.make
    }.should change(ActionMailer::Base.deliveries, :length).by(+1)

    ActionMailer::Base.deliveries.last.subject.should include("SliceCraft project")
  end

  it "should generate an access code" do
    Project.make.reload.access_code.size.should == 20
  end

  it "should not regenerate the access code on save" do
    project = Project.make
    access_code = project.access_code
    project.update_attributes!(:preview_built => true)

    project.reload.access_code.should == access_code
  end

  it "should only mail update if its made by a client" do
    project = Project.make
    proc {
      project.save
    }.should_not change(ActionMailer::Base.deliveries, :length).by(+1)


    proc {
      project.update_attributes({:update_by_client => true})
    }.should change(ActionMailer::Base.deliveries, :length).by(+1)

  end

  context "comments" do

    before do
      @project = Project.make
    end

    it "should validate the text" do
      @project.comments.create(:text => '', :by_client => true).should_not be_valid
    end

    it "should validate that by_client is true or false" do
      @project.comments.create(:text => 'Text').should_not be_valid

    end

    it "should create a comment for a project" do
      comment = @project.comments.build(:text => 'Text')
      comment.by_client = true
      comment.save!

      @project.reload.comments.first.text.should == 'Text'
    end

  end

end
