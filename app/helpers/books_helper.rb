module BooksHelper

  def unsaved_chunks
    count = 0
    @books.each do |book|
      count += book.number_of_chunks_with_at_least_one_autosave
    end
    count
  end
end
