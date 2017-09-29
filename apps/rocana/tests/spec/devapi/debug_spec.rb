require 'spec_helper'

describe "server", :sudo => false do



  describe command("whoami"), :sudo => false do
    it "debug" do
      expect(subject.stdout).to match(/root/)
    end
  end

  describe command("java -version 2>&1") do
    it "java version" do
      expect(subject.stdout).to match(/1.8.0_65/)
    end
  end


end
