class Bible < ApplicationRecord
  serialize :books, Array
  has_many :verses
  cattr_accessor :bible_api
  @@bible_api = BibleApi.new
  @@default_format_string = "{content} -{reference:book} {reference:chapter}:{reference:verse} ({reference:abbreviation})"

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
    self.books.each_index do |ind|
      load_book(ind)
    end
  end
  def load_book(book_index)
    if(self.books.nil? || self.books.length == 0)
      self.books = @@bible_api.books(bible_id:self.bible_id).map(&:symbolize_keys)
      save
    end
    book = books[book_index]
    if(books[book_index][:chapters].nil? || books[book_index][:chapters].length == 0)
      books[book_index][:chapters] = @@bible_api.chapters(bible_id:self.bible_id,book_id:books[book_index][:id]).map(&:symbolize_keys).collect{|c| {id:c[:id], number:c[:number], name:c[:reference]}}
      load_chapters(book_index)
      save
    end
    return
  end
  def load_chapters(book_index)
    books[book_index][:chapters].each_index do |i|
      self.save
      # chapter = books[b][:chapters][i]
      load_chapter(book_index,i)
      # for verse_number in 1..chapter[:last_verse_number]

      # end
    end
    self.save
  end
  def load_verse(**args)
    if(args[:query].present?)
      book_index, chapter_index, verse_number = args[:query].split('.')
    else
      book_index = args[:book_index]
      chapter_index = args[:chapter_index]
      verse_number = args[:verse_number]
    end
    if(book_index.is_a? String)
      book_index = self.books.index(self.books.select{|book| book[:id] == book_index}.first)
    end
    chapter_index = chapter_index.to_i
    verse_number = verse_number.to_i
    if(self.books[book_index][:chapters][chapter_index][:last_verse_number].nil?)
      load_chapter(book_index,chapter_index)
    end
    if(self.books[book_index][:chapters][chapter_index][:last_verse_number] >= verse_number)
      if(Verse.where({verse_id:"#{self.books[book_index][:chapters][chapter_index][:id]}.#{verse_number.to_s}"}).select{|v| v.bible.bible_id == self.bible_id}.length == 0)
        puts "Loading #{self.books[book_index][:chapters][chapter_index][:id]}.#{verse_number.to_s}"
        verse_data = @@bible_api.verse(bible_id:self.bible_id,verse_id:"#{self.books[book_index][:chapters][chapter_index][:id]}.#{verse_number.to_s}").symbolize_keys
        return Verse.create(bible:self,verse_id:"#{self.books[book_index][:chapters][chapter_index][:id]}.#{verse_number.to_s}",content:verse_data[:content])
      else
        puts "Verse #{self.books[book_index][:chapters][chapter_index][:id]}.#{verse_number.to_s} already loaded."
        return Verse.where({verse_id:"#{self.books[book_index][:chapters][chapter_index][:id]}.#{verse_number.to_s}"}).select{|v| v.bible.bible_id == self.bible_id}.first
      end
    end
    save
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
    if(self.books[book_index][:chapters][chapter_index][:sections].nil?)
      self.books[book_index][:chapters][chapter_index][:sections] = []
    end
    # if(self.books[book_index][:chapters][chapter_index][:sections].length == 0)
    #   puts "Enumerating sections for #{self.books[book_index][:chapters][chapter_index][:name]}."
    #   self.books[book_index][:chapters][chapter_index][:sections] = @@bible_api.sections(bible_id:self.bible_id,range_type:"chapter",range_id:self.books[book_index][:chapters][chapter_index][:id]).map(&:symbolize_keys)
    # else
    #   puts "#{self.books[book_index][:chapters][chapter_index][:name]} already has enumerated sections."
    # end
  end

  def search(reference, format_string=nil)
    reference = parse_reference(reference)
    puts reference
    verse_query = reference[:query]
    if(format_string.nil?)
      format_string = @@default_format_string
    end
    appendstr = ""

    if(verse_query.is_a? Array)
      result = verse_query.map{|v| load_verse(query:v).unwrapped }.join(" ")
      reference[:verse] = "#{reference[:verses_start]}-#{reference[:verses_end]}"
    else
      result = load_verse(query:verse_query).unwrapped
      reference[:verse] = reference[:verse_number]
      appendstr = "<style>.v{display:none;}</style>"
    end

    output = format_string.gsub("{content}", result)
    output = output.gsub("{reference:book}", reference[:book])
    output = output.gsub("{reference:chapter}", reference[:chapter])
    output = output.gsub("{reference:verse}", reference[:verse])
    output = output.gsub("{reference:abbreviation}",  self.abbreviation)
    output = output+appendstr
    return output
  end
  def parse_reference(str)
    data = str.match(/(?<prefix>\S?[ ]?)(?<book>\S+)[\s]+(?<chapter>\d+)[:](?<verses_start>\d+)-(?<verses_end>\d+)/)
    if(data.nil?)
      data = str.match(/(?<prefix>\S?[ ]?)(?<book>\S+)[\s]+(?<chapter>\d+)[:](?<verse_number>\d+)/)
    end
    reference = {}

    reference[:book] = "#{data[:prefix]}#{data[:book]}"
    book_id = self.books.select{|book| book[:name] == reference[:book]}.first[:id]
    reference[:chapter] = data[:chapter]
    if(data.names.include?("verse_number"))
      reference[:verse_number] = data[:verse_number]
    else
      reference[:verses_start] = data[:verses_start]
      reference[:verses_end] = data[:verses_end]
    end

    if(data.names.include? "verses_start")
      reference[:query] = (data[:verses_start]..data[:verses_end]).map{|verse_number| "#{book_id}.#{data[:chapter]}.#{verse_number}"}
    else
      reference[:query] = "#{book_id}.#{data[:chapter]}.#{data[:verse_number]}"
    end
    return reference
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
