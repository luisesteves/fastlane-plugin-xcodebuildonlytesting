describe Fastlane::Actions::XcodebuildonlytestingAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The xcodebuildonlytesting plugin is working!")

      Fastlane::Actions::XcodebuildonlytestingAction.run(nil)
    end
  end
end
