RSpec.describe "Fraud" do
  let(:postcode) { "S10 2FL"}
  let(:card_number) {"1111"}
  let(:card_expiry) {"06/2018"}
  specify { expect(postcode).to exist }

  
end




