class SitemapController < ApplicationController
  def index
    headers['Content-Type'] = 'application/xml'
    sitemap = XmlSitemap::Map.new('cozi.ly') do |m|
      m.add(:url => root_path, :period => :daily, :priority => 0.1)
      m.add(:url => browse_path, :period => :hourly, :priority => 1.0)
      m.add(:url => about_page_path, :period => :weekly, :priority => 0.5)
      m.add(:url => faq_page_path, :period => :weekly, :priority => 0.5)
      m.add(:url => terms_of_service_page_path, :period => :weekly, :priority => 0.5)
      m.add(:url => privacy_policy_page_path, :period => :weekly, :priority => 0.5)
      Apartment.with_state(:published).each do |apartment|
        m.add(
          :url => apartment_path(apartment),
          :updated => apartment.updated_at,
          :priority => 1.0,
          :period => :daily
        )
      end
      Neighborhood.all.each do |neighborhood|
        m.add(
          :url => neighborhood_path(neighborhood),
          :updated => neighborhood.updated_at,
          :priority => 1.0,
          :period => :hourly
        )
      end
    end
    render :text => sitemap.render
  end
end