require "spec_helper"
module TimeLogger

  describe Result do

    describe ".valid?" do
      it "returns a boolean if the instance variable contains any errors" do
        result = Result.new("The date you entered is in the past, please enter a valid date")
        expect(result.valid?).to eq(false)
      end
    end
  end
end
