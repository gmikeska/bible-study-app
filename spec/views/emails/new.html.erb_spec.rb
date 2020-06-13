require 'rails_helper'

RSpec.describe "emails/new", type: :view do
  before(:each) do
    assign(:email, Email.new(
      name: "MyString",
      subject: "MyText",
      content: "MyText"
    ))
  end

  it "renders new email form" do
    render

    assert_select "form[action=?][method=?]", emails_path, "post" do

      assert_select "input[name=?]", "email[name]"

      assert_select "textarea[name=?]", "email[subject]"

      assert_select "textarea[name=?]", "email[content]"
    end
  end
end
