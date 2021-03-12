class ContentAsset < ApplicationRecord
  VALID_FILE_EXTENSIONS = %w[.pdf .doc .docx .jpeg].freeze
  VALID_CONTENT_TYPE = %w[
    application/pdf
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    image/jpeg
  ].freeze

  has_one_attached :asset_file
  validates :title, presence: true
  validates :asset_file, presence: true
  validates :alt_text, presence: true
  validates :asset_file, antivirus: true
  validate :asset_file_ext_validation
  validates :asset_file, content_type: VALID_CONTENT_TYPE

  def asset_file_ext_validation
    return unless asset_file.attached?

    errors.add(:asset_file, :wrong_extension) if VALID_FILE_EXTENSIONS.none? {|extension| asset_file.blob.filename.to_s.end_with?(extension)}
  end

end
