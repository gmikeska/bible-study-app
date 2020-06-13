class Bible < ApplicationRecord
  serialize :books, Array
  has_many :verses
  @@bible_api = BibleApi.new


  def is_complete?
    if(self.books.length == 0)
      return false
    else
      books.each do |book|
        if(book[:chapters].nil?)
          return false
        else
          book[:chapters].each do |chapter|
            if(chapter[:last_verse_number].nil?)
              return false
            end
          end
        end
      end
      return true
    end
  end

  def load_books
    if(self.books.nil? || self.books.length == 0)
      self.books = @@bible_api.books(bible_id:self.bible_id).map(&:symbolize_keys)
      save
    end
    self.books.each_index do |b|
      book = books[b]
      if(books[b][:chapters].nil? || books[b][:chapters].length == 0)
        books[b][:chapters] = @@bible_api.chapters(bible_id:self.bible_id,book_id:books[b][:id]).map(&:symbolize_keys).collect{|c| {id:c[:id], number:c[:number], name:c[:reference]}}
        save
      end
      books[b][:chapters].each_index do |i|
        self.save
        # chapter = books[b][:chapters][i]
        load_chapter(b,i)
        # for verse_number in 1..chapter[:last_verse_number]
        #   if(Verse.where({verse_id:"#{chapter[:id]}.#{verse_number.to_s}"}).select{|v| v.bible.bible_id == self.bible_id}.length == 0)
        #     puts "Loading #{chapter[:id]}.#{verse_number.to_s}"
        #     verse_data = @@bible_api.verse(bible_id:self.bible_id,verse_id:"#{chapter[:id]}.#{verse_number.to_s}").symbolize_keys
        #     Verse.create(bible:self,verse_id:"#{chapter[:id]}.#{verse_number.to_s}",content:verse_data[:content])
        #   else
        #     puts "Verse #{chapter[:id]}.#{verse_number.to_s} already loaded."
        #   end
        #   save
        # end
      end
      self.save
    end
  end

  def load_chapter(book_index,chapter_index)
    if(self.books[book_index][:chapters][chapter_index][:last_verse_number].nil?)
      puts "Loading verse count for #{self.books[book_index][:chapters][chapter_index][:name]}"
      self.books[book_index][:chapters][chapter_index][:last_verse_number] = @@bible_api.verses(bible_id:self.bible_id,chapter_id:self.books[book_index][:chapters][chapter_index][:id]).map(&:symbolize_keys).last[:id].split(".").last.to_i
      self.books_will_change!
      self.save
    else
      puts "#{self.books[book_index][:chapters][chapter_index][:name]} already has verse count."
    end
  end

  def self.list_bibles
    all_bibles = @@bible_api.bibles.map(&:symbolize_keys)
    all_bibles.each do |bible|
      Bible.create(bible_id:bible[:id],dblId:bible[:dblId],name:bible[:name],language:bible[:language]["name"],language_id:bible[:language]["id"],nameLocal:bible[:language]["nameLocal"],abbreviation:bible[:abbreviation],abbreviationLocal:bible[:abbreviationLocal],description:bible[:description],descriptionLocal:bible[:descriptionLocal])
    end
  end

  def self.load_bibles(whereQuery)
    if(self.all.length == 0)
      self.list_bibles
    end
    to_load = Bible.where(whereQuery).select{|b| !b.is_complete?}
    to_load.each do |bible|
      bible.load
    end
  end

end
