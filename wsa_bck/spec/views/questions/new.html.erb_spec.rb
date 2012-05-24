require 'spec_helper'

describe "questions/new.html.erb" do
  before(:each) do
    assign(:question, stub_model(Question,
      :title => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => questions_path, :method => "post" do
      assert_select "input#question_title", :name => "question[title]"
      assert_select "textarea#question_body", :name => "question[body]"
    end
  end
end
