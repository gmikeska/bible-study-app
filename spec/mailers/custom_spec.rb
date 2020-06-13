require "rails_helper"

RSpec.describe CustomMailer, type: :mailer do
  describe "dynamic" do
    let(:mail) { CustomMailer.dynamic }

    it "renders the headers" do
      expect(mail.subject).to eq("Dynamic")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
