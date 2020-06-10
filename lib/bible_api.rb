require 'uri'
require 'net/http'
require 'date'
require "awesome_print"
class BibleApi
  cattr_accessor :queryInterval
  @@lastQuery = 0
  @@queryInterval = 10
  def self.loadBibles
    allBibles = Bible.where({language_id:"eng"})
    count =  2
    allBibles.each do |bible|
      if(!bible.isEnumerated?)
        if(bible.loadBible)
          count = count - 1
          if(count == 0)
            count = 2
            puts "Sleeping 1 minute."
            sleep(60)
          end
        end
      end
    end
  end

  def self.callAPI(url, interval=nil)
    if(!interval.nil?)
      oldQueryInterval = @@queryInterval
      @@queryInterval = interval
    end
    if(!@@lastQuery.nil?)
      currentElapsed = DateTime.now.strftime('%s').to_i - @@lastQuery
      if(currentElapsed < @@queryInterval)
        if(@@queryInterval - currentElapsed > 2)
          puts "Waiting "+(@@queryInterval - currentElapsed).to_s+" seconds. Interval is set to "+@@queryInterval.to_s+"."
        end
        sleep(@@queryInterval - currentElapsed)
      end
    end
    url = URI(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request['api-key'] = ENV["BIBLE_API_KEY"]
    request['content-type'] = "json"
    response = http.request(request)
    @@lastQuery = DateTime.now.strftime('%s').to_i
    if(response.code == "200")
      # puts "success"
      return JSON.parse(response.read_body)['data']
    else
      puts response.code.to_s+" "+response.message
    end
    if(!interval.nil?)
      @@queryInterval = oldQueryInterval
    end
  end

  def self.getReference(ref)

    verses = []
    ref['verses'].each do |verseId|
      ap("Getting "+verseId)
      verses.push(getVerse(ref['bibleId'], verseId))
    end
    ref['verses'] = verses
    @@queryInterval = oldQueryInterval
    return ref
  end

  def self.getBibles
    callAPI("https://api.scripture.api.bible/v1/bibles")
  end

  def self.getBooks(bibleId, interval=nil)
    url = "https://api.scripture.api.bible/v1/bibles/#{bibleId}/books"
    callAPI(url, interval)
  end

  def self.getChapters(bibleId, bookId, interval=nil)
    url = "https://api.scripture.api.bible/v1/bibles/#{bibleId}/books/#{bookId}/chapters"
    callAPI(url, interval)
  end

  def self.getPassage(bibleId, passageId, interval=nil)
    url = "https://api.scripture.api.bible/v1/bibles/#{bibleId}/passages/#{passageId}"
    callAPI(url, interval)
  end

  def self.getSections(bibleId,rangeType,rangeId, interval=nil)
    # for instance: rangeType = "book"
    #               bookId => rangeId
    url = "https://api.scripture.api.bible/v1/bibles/#{bibleId}/#{rangeType}/#{rangeId}/sections"
    callAPI(url, interval)
  end

  def self.getSection(bibleId,sectionId, interval=nil)
    url = "https://api.scripture.api.bible/v1/bibles/#{bibleId}/sections/#{sectionId}"
    callAPI(url, interval)
  end

  def self.getVerses(bibleId, chapterId, interval=nil)
    url = "https://api.scripture.api.bible/v1/bibles/#{bibleId}/chapters/#{chapterId}/verses"
    callAPI(url, interval)
  end
  def self.getVerse(bibleId, verseId, interval=nil)
    url = "https://api.scripture.api.bible/v1/bibles/#{bibleId}/verses/#{verseId}"
    callAPI(url, interval)
  end

end
