class AutosaveChunk < ActiveRecord::Base
  attr_accessible :title, :section, :content, :updated_at, :created_at

  belongs_to :chunk

  def equal?(_title, _section, _content)
    return title == _title && section == _section && content == _content
  end

  def new_autosave?
    #if last edit is more than 5 minutes ago or creation more than 1 hour ago
    return updated_at + 1.minutes < DateTime.now || created_at + 10.minutes < DateTime.now
  end

end
