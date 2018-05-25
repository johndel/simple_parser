require 'open-uri'
class ParseDomainJob < ApplicationJob
  queue_as :default

  def perform(domain_id)
    domain = Domain.find(domain_id)
    html = RestClient.get(domain.url).to_s
    metadatas = html.scan(/<meta(.*?>)/).flatten.map{|m| "<meta#{m}"}

    parsed_html = Nokogiri::HTML(html)
    links = parsed_html.css('a').map {|a| a.attributes["href"].try(:value) }
    facebook_link = links.map {|l| l if l && (l.include?("www.facebook.com") || l.include?("facebook.com")) }.try(:compact).try(:first)
    youtube_link = links.map {|l| l if l && (l.include?("www.youtube.com") || l.include?("youtube.com")) }.try(:compact).try(:first)
    twitter_link = links.map {|l| l if l && (l.include?("www.twitter.com") || l.include?("twitter.com")) }.try(:compact).try(:first)
    instagram_link = links.map {|l| l if l && (l.include?("www.instagram.com") || l.include?("instagram.com")) }.try(:compact).try(:first)

    headers1 = parsed_html.css('h1').map{|h| h.try(:text)}
    headers2 = parsed_html.css('h2').map{|h| h.try(:text)}
    headers3 = parsed_html.css('h3').map{|h| h.try(:text)}
    headers4 = parsed_html.css('h4').map{|h| h.try(:text)}
    headers5 = parsed_html.css('h5').map{|h| h.try(:text)}
    headers6 = parsed_html.css('h6').map{|h| h.try(:text)}

    strongs = parsed_html.css('strong').map{|h| h.try(:text)}
    bolds = parsed_html.css('b').map{|h| h.try(:text)}

    parsed_at = Time.now
    domain.update(facebook: facebook_link,
                  youtube: youtube_link,
                  twitter: twitter_link,
                  instagram: instagram_link,
                  parsed_at: parsed_at)

    metadatas.each { |metadata| Metadata.create(metadata: metadata, parsed_at: parsed_at, domain_id: domain.id ) }

    headers1.each { |h1| Header.create(header_type: "h1", phrase: h1, parsed_at: parsed_at, domain_id: domain.id) }
    headers2.each { |h2| Header.create(header_type: "h2", phrase: h2, parsed_at: parsed_at, domain_id: domain.id) }
    headers3.each { |h3| Header.create(header_type: "h3", phrase: h3, parsed_at: parsed_at, domain_id: domain.id) }
    headers4.each { |h4| Header.create(header_type: "h4", phrase: h4, parsed_at: parsed_at, domain_id: domain.id) }
    headers5.each { |h5| Header.create(header_type: "h5", phrase: h5, parsed_at: parsed_at, domain_id: domain.id) }
    headers6.each { |h6| Header.create(header_type: "h6", phrase: h6, parsed_at: parsed_at, domain_id: domain.id) }

    strongs.each  { |strong| Strong.create(phrase: strong, parsed_at: parsed_at, domain_id: domain.id) }
    bolds.each    { |bold|   Strong.create(phrase: bold, parsed_at: parsed_at, domain_id: domain.id) }
  end
end
