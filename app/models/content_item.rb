class ContentItem < ApplicationRecord
  include ActiveModel::Transitions
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  scope :last_updated_at, -> { order(updated_at: :desc).select('updated_at').first.updated_at }

  acts_as_paranoid

  belongs_to :creator, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  belongs_to :content_type
  has_many :field_items, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :field_items

  default_scope { order(created_at: :desc) }

  validates :creator_id, :content_type_id, presence: true

  after_save :index

  state_machine do
    state :draft
    state :scheduled

    event :schedule do
      transitions :to => :scheduled, :from => [:draft]
    end

    event :draft do
      transitions :to => :draft, :from => [:scheduled]
    end
  end

  def publish_state
    PublishStateService.new.content_item_state(self)
  end

  def rss_url(base_url, slug_field_id) # TODO: abstract RSS to separate app once API is implemented
    slug = field_items.find_by_field_id(slug_field_id).data.values.join
    "#{base_url}#{slug}"
  end

  def rss_date(date_field_id) # TODO: abstract RSS to separate app once API is implemented
    date = field_items.find_by_field_id(date_field_id).data["timestamp"]
    Date.parse(date).rfc2822
  end

  def rss_author(field_id) # TODO: abstract RSS to separate app once API is implemented
    author = field_items.find_by_field_id(field_id).data["author_name"]
    "editorial@careerbuilder.com (#{author})"
  end

  def as_indexed_json(options = {})
    json = as_json
    # json[:tenant_id] = TODO

    field_items.each do |field_item|
      field_type = field_item.field.field_type_instance(field_name: field_item.field.name)
      json.merge!(field_type.field_item_as_indexed_json_for_field_type(field_item))
    end

    json
  end

  def index
    __elasticsearch__.client.index(
      {index: content_type.content_items_index_name,
       type: self.class.name.parameterize('_'),
       id: id,
       body: as_indexed_json}
    )
  end

  # Metaprograms a number of convenience methods for content_items
  def method_missing(*args)
    if args[0].to_s.include?("?")
      # Used to check state - allows for methods such as #published? and #expired?
      # Will return true if the active_state corresponds to the name of the method
      "#{publish_state.downcase}?" == args[0].to_s
    else
      # Used to query for any field on the relevant ContentType and return data from the content_item
      field_items.select { |field_item| field_item.field.name.parameterize(separator: '_') == args[0].to_s }.first.data.values[0]
    end
  end
end
