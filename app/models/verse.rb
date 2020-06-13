class Verse < ApplicationRecord
  belongs_to :bible
  def unwrapped
    u = content
    u = u.gsub('<p class="p">',"")
    u = u.gsub("</p>","")
    return u
  end
  def bibleId
    return bible.bibleId
  end
  def bookId
    data = verseId.split('.')
    return data[0]
  end

  def chapterId
    data = verseId.split('.')
    return data[0]+"."+data[1]
  end

  def verseNumber
    data = verseId.split('.')
    return data[2]
  end

  def bookName
    book = bible.books.select {|book| book["id"] == bookId} .first
    return book["name"]
  end

  def chapterNumber
    book = bible.books.select {|book| book["id"] == bookId} .first
    chapter = book['chapters'].select {|c| c["id"] == chapterId} .first
    return chapter["number"]
  end

  def reference
    return bookName+" "+chapterNumber+":"+verseNumber
  end
end
