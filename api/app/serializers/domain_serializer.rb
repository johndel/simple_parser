class DomainSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :url, :domain, :parsed_at, :facebook, :twitter, :instagram, :youtube
  # has_many :strongs
  # has_many :headers
  # has_many :metadatas
  #
  attributes :metadatas do |domain|
    Metadata.where(domain_id: domain.id, parsed_at: domain.parsed_at)
  end

  attributes :strongs do |domain|
    Strong.where(domain_id: domain.id, parsed_at: domain.parsed_at)
  end

  attributes :headers do |domain|
    Header.where(domain_id: domain.id, parsed_at: domain.parsed_at)
  end
end
