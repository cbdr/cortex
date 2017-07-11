class Webpage < ApplicationRecord
  include FindByTenant
  include SearchableWebpage

  serialize :tables_widget
  serialize :charts_widget

  scope :agnostic_guess_by_url, ->(url) { where('url LIKE :url', url: "%#{url}%") }

  acts_as_paranoid
  acts_as_taggable_on :seo_keywords

  belongs_to :user
  has_many :snippets, inverse_of: :webpage
  has_many :documents, through: :snippets, :dependent => :destroy

  validates_presence_of :user

  accepts_nested_attributes_for :snippets

  def self.agnostic_find_by_url(url)
    url = protocol_agnostic_url(url)
    agnostic_guess_by_url(url).find { |webpage| protocol_agnostic_url(webpage.url) == url }
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

  def charts_widget_yaml
    charts_widget.to_yaml
  end

  def charts_widget_yaml= p
    self.charts_widget = YAML.load(p)
  end

  def charts_widget_json
    charts_widget.to_json
  end

  def charts_widget_json= p
    self.charts_widget = JSON.parse(p, quirks_mode: true) # Quirks mode will let us parse a null JSON object
  end

  def accordion_group_widget_yaml
    accordion_group_widget.to_yaml
  end

  def accordion_group_widget_yaml= p
    self.accordion_group_widget = YAML.load(p)
  end

  def accordion_group_widget_json
    accordion_group_widget.to_json
  end

  def accordion_group_widget_json= p
    self.accordion_group_widget = JSON.parse(p, quirks_mode: true) # Quirks mode will let us parse a null JSON object
  end

  private

  def self.protocol_agnostic_url(url)
    uri = Addressable::URI.parse(url)
    path = uri.path == '/' ? uri.path : uri.path.chomp('/')
    "://#{uri.authority}#{path}"
  end
end
