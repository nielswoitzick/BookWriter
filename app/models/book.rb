class Book < ActiveRecord::Base

  attr_accessible :title, :edition, :published, :genre, :abstract, :tags, :user_ids, :closed

  has_and_belongs_to_many :users
  has_many :chunks

  validates_presence_of :title, :edition, :published
  validates :edition, :uniqueness => {:scope => :title}, numericality: { only_integer: true, greater_than: 0 }

  before_destroy :destroy_chunks

  def sliced_attributes
    attributes.slice('title', 'genre', 'abstract', 'tags')
  end

  def published?
    !published.nil?
  end

  def has_chunks?
    !chunks.empty?
  end

  def max_chunk_position
    has_chunks? ? chunks.max_by(&:position).position : 0
  end

  def users_list
    users.collect { |u| u.username }.join(',')
  end

  def users_list_real_names
    users.collect { |u| u.first_name + ' ' + u.last_name }.join(',')
  end

  def has_autosave_chunks?
    chunks.each do |chunk|
      return true if chunk.has_autosave_chunks?
    end
    false
  end

  def number_of_chunks_with_at_least_one_autosave
    count = 0
    chunks.each do |chunk|
      if chunk.has_autosave_chunks?
        count += 1
      end
    end
    count
  end

  def sorted_chunks
    chunks.sort {|a,b| a.section.to_s.casecmp b.section}
  end

  private
  def destroy_chunks
    chunks.each do |chunk|
      chunk.destroy
    end
  end

end