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
        end
      end
      return true
    end
  end

  def load
    if(self.books.nil? || self.books.length == 0)
      self.books = @@bible_api.books(bible_id:self.bible_id).map(&:symbolize_keys)
      save
    end
    self.books.each do |book|
      if(book[:chapters].nil? || book[:chapters].length == 0)
        book[:chapters] = @@bible_api.chapters(bible_id:self.bible_id,book_id:book[:id]).map(&:symbolize_keys).collect{|c| {id:c[:id], number:c[:number], name:c[:reference]}}

        book[:chapters].each do |chapter|
          chapter[:last_verse_number] = @@bible_api.verses(bible_id:self.bible_id,chapter_id:chapter[:id]).map(&:symbolize_keys).last[:id].split(".").last.to_i
          for verse_number in 1..chapter[:last_verse_number]
            if(Verse.where({bible:self,verse_id:"#{chapter[:id]}.#{verse_number.to_s}"}).length == 0)
              verse_data = @@bible_api.verse(bible_id:self.bible_id,verse_id:"#{chapter[:id]}.#{verse_number.to_s}").symbolize_keys
              Verse.create(bible:self,verse_id:"#{chapter[:id]}.#{verse_number.to_s}",content:verse_data[:content])
            end
          end
        end
      end
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
