# encoding: utf-8

class Chunk < ActiveRecord::Base

  has_paper_trail :ignore => [:position]

  default_scope { order('position ASC') }

  attr_accessible :title, :section, :content, :user_id, :book_id, :position, :original_updated_at, :autosave_chunks
  attr_writer :original_updated_at

  belongs_to :user
  belongs_to :book
  has_many :autosave_chunks

  before_validation { self.position ||= book.max_chunk_position + 1 }
  before_destroy :destroy_autosave_chunks
  after_update :destroy_autosave_chunks

  validates_presence_of :title, :section, :book_id, :user_id, :position
  validates :title, :uniqueness => {:scope => :book_id}
  validates :position, :uniqueness => {:scope => :book_id}
  validates :section, :format => {:with => /\A[1-9][0-9]*(\.[1-9][0-9]*)*\z/,
                                  :message => I18n.t('activerecord.messages.invalid_section')}
  validate :handle_conflict, only: :update

  def username
    user.username
  end

  def sliced_attributes
    attributes.slice('title', 'section', 'content', 'user_id')
  end

  def tag_id
    'chunk_' + id.to_s
  end

  def tag_tree_id
    'chunk_in_tree_' + id.to_s
  end

  def original_updated_at
    @original_updated_at || updated_at.to_f
  end

  def has_autosave_chunks?
    !autosave_chunks.empty?
  end

  def destroy_autosave_chunks
    autosave_chunks.each do |autosave_chunk|
      autosave_chunk.destroy
    end
  end

  private
  def handle_conflict
    if @conflict || updated_at.to_f > original_updated_at.to_f
      @conflict = true
      @original_updated_at = nil
      errors.add :base, I18n.t('views.chunk.messages.merge_changes')
      changes.each do |attribute, values|
        unless attribute == 'content'
          errors.add attribute, "#{I18n.t('views.chunk.messages.was_changed_to')} #{values.first}."
        else
          errors.add attribute, I18n.t('views.chunk.messages.was_changed')
          self.content = "== #{I18n.t('views.chunk.messages.content_other')} =="
          self.content << values.first
          self.content << "== #{I18n.t('views.chunk.messages.content_own')} =="
          self.content << values.last
        end
      end
    end
  end

end