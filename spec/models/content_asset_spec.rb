require "rails_helper"

RSpec.describe ContentAsset, type: :model do
  describe "with a valid attached file" do
    subject { ContentAsset.new }

    before(:each) do
      subject.title = "Title"
      subject.alt_text = "Sample Alt Text"
      subject.asset_file.attach(io: File.open("spec/fixtures/sample.jpeg"), filename: "sample.jpeg", content_type: "image/jpeg")
      subject.save!
    end

    it "has a file attached" do
      expect(subject.asset_file).to be_attached
    end
  end

  describe "with a file with the wrong extension" do
    let(:asset_file) { fixture_file_upload("spec/fixtures/sample.jpeg")}

    it 'is not valid' do
      expect(subject.save).to be false
    end

    it 'has the correct error message' do
      asset = ContentAsset.new(title: "Some Content")
      asset.save!
      expect(asset).to have no_errors  
    end
  end

  describe "with infected file" do
    subject { ContentAsset.new }
    before(:each) do
    end
  end

  describe "required attributes" do
    subject { ContentAsset.new }
    before(:each) do
      subject.validate
    end
    it "requires a title" do
      expect(subject.errors[:title]).to include("can't be blank")
    end
    it "requires an asset to be uploaded" do
      expect(subject.errors[:asset_file]).to include("can't be blank")
    end
    it "requires an alt text for the asset" do
      expect(subject.errors[:alt_text]).to include("can't be blank")
    end
  end
end
