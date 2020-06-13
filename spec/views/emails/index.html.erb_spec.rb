require 'rails_helper'

RSpec.describe "emails/index", type: :view do
  before(:each) do
    assign(:emails, [
      Email.create!(
        name: "Name",
        subject: "MyText",
        content: "MyText"
      ),
      Email.create!(
        name: "Name",
        subject: "MyText",
        content: "MyText"
      )
    ])
  end

  it "renders a list of emails" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
