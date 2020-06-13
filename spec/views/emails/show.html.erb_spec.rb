require 'rails_helper'

RSpec.describe "emails/show", type: :view do
  before(:each) do
    @email = assign(:email, Email.create!(
      name: "Name",
      subject: "MyText",
      content: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
