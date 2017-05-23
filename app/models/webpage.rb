class Webpage < ApplicationRecord
  include FindByTenant
  include SearchableWebpage

  serialize :tables_widget

  acts_as_paranoid
  acts_as_taggable_on :seo_keywords

  belongs_to :user
  has_many :snippets, inverse_of: :webpage
  has_many :documents, through: :snippets, :dependent => :destroy

  accepts_nested_attributes_for :snippets

  def self.find_by_protocol_agnostic_url(suffix)
    Webpage.find { |webpage| Webpage.protocol_agnostic_url(webpage.url) == suffix }
  end

  def tables_widget_yaml
    tables_widget.to_yaml
  end

  def tables_widget_yaml= p
    self.tables_widget = YAML.load(p)
  end

  def tables_widget_json
    tables_widget.to_json
  end

  def tables_widget_json= p
    self.tables_widget = JSON.parse(p, quirks_mode: true) # Quirks mode will let us parse a null JSON object
  end

  private

  def self.protocol_agnostic_url(url)
    Rails.cache.fetch("Webpages/#{url}", expires_in: 7.days) do
      uri = Addressable::URI.parse(url)
      path = uri.path == '/' ? uri.path : uri.path.chomp('/')
      "://#{uri.authority}#{path}"
    end
  end
end
