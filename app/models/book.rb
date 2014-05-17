class Book < ActiveRecord::Base
  attr_accessible :abstract, :edition, :genre, :published, :tags, :title, :user_ids

  has_and_belongs_to_many :users
  has_many :chunks

  before_destroy :destroy_chunks

  validates :title, :presence => true
  validates :edition, numericality: { only_integer: true, greater_than: 0 }
  validates :published, :presence => true

  def has_chunks?
    !chunks.empty?
  end

  def destroy_chunks
    chunks.each do |chunk|
      chunk.destroy
    end
  end
end
