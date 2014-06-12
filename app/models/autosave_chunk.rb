class AutosaveChunk < ActiveRecord::Base
  attr_accessible :content, :section, :title

  belongs_to :chunk
end
