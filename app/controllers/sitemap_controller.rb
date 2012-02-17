class SitemapController < ApplicationController
  def index
    headers['Content-Type'] = 'application/xml'
    sitemap = XmlSitemap::Map.new('cozi.ly') do |m|
      m.add browse_path, period: :hourly, priority: 1.0
      m.add about_page_path, period: :weekly, priority: 0.5
      m.add faq_page_path, period: :weekly, priority: 0.5
      m.add terms_of_service_page_path, period: :weekly, priority: 0.5
      m.add privacy_policy_page_path, period: :weekly, priority: 0.5
      m.add neighborhoods_path, period: :weekly, priority: 0.5
      Apartment.with_state(:published).each do |apartment|
        m.add apartment_path(apartment), updated: apartment.updated_at, priority: 1.0, period: :daily
      end
      Neighborhood.all.each do |neighborhood|
        m.add neighborhood_path(neighborhood), updated: neighborhood.updated_at, priority: 1.0, period: :hourly
      end
      Building.all.each do |building|
        m.add building_path(building), updated: building.updated_at, priority: 1.0, period: :daily
      end
    end
    render xml: sitemap.render
  end
end
