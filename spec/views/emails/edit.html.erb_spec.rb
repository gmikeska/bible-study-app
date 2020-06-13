require 'rails_helper'

RSpec.describe "emails/edit", type: :view do
  before(:each) do
    @email = assign(:email, Email.create!(
      name: "MyString",
      subject: "MyText",
      content: "MyText"
    ))
  end

  it "renders the edit email form" do
    render

    assert_select "form[action=?][method=?]", email_path(@email), "post" do

      assert_select "input[name=?]", "email[name]"

      assert_select "textarea[name=?]", "email[subject]"

      assert_select "textarea[name=?]", "email[content]"
    end
  end
end
