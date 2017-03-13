class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join('_')

  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }
  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search = "")
    search.blank? ? all : where('title iLIKE ?', "%#{search}%").order(created_at: :asc)
  end

  def average_rating
    reviews.average(:rating).to_f.round(1) if reviews.any?
  end
  
  def self.search(query, options={})
    search_definition = base_query(query)
    add_field_to_query(search_definition, 'reviews.content') if options[:reviews].present?
    add_rating_filter(search_definition, options) if rating_included?(options)
    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(
      methods: [:average_rating],
      only: [:title, :description, :small_cover],
      include: {
        reviews: { only: [:content] }
      }
    )
  end

  private

  def self.add_rating_filter(query, options)
    query[:query][:bool][:must]= {
      range: { 
        average_rating: {
          gte: (options[:rating_from] if options[:rating_from].present?),
          lte: (options[:rating_to] if options[:rating_to].present?)
        }
      }
    }
  end

  def self.rating_included?(options)
    options[:rating_from].present? || options[:rating_to].present?
  end

  def self.add_field_to_query(query, field)
    query[:query][:bool][:should][:multi_match][:fields] << field
  end

  def self.base_query(query)
    {
      query: {
        bool: {
          should: {
            multi_match: {
              query: query,
              fields: ['title^100', 'description^50'],
              operator: "and"
            }
          }
        }
      },
      highlight: {
        pre_tags: ["<em class='label label-highlight'>"],
        post_tags: ["</em>"],
        fields: {:"*" => {} }
      }
    }
  end

end