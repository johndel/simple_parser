class Domain < ApplicationRecord
  has_many :metadatas, dependent: :destroy
  has_many :strongs, dependent: :destroy
  has_many :headers, dependent: :destroy
end
