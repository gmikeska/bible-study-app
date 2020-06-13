class BibleApi < ApiEngine
  def initialize(**options)
    url = "https://api.scripture.api.bible/v1"
    if(options[:params].nil?)
      options[:params] = {}
    end

    options[:params]['content-type'] = "json"
    if(options[:api_key].nil? && options[:params]['api-key'].nil?)
      options[:params]['api-key'] = ENV.fetch("BIBLE_API_KEY")
    elsif(options[:api_key].present?)
      options[:params]['api-key'] = options[:api_key]
    end
    
    super(url,options)


    endpoint "bibles"
    endpoint "books", "/bibles/{bible_id}/books"
    endpoint "chapters", "/bibles/{bible_id}/books/{book_id}/chapters"
    endpoint "passage", "/bibles/{bible_id}/passages/{passage_id}"
    endpoint "sections", "/bibles/{bible_id}/{range_type}/{range_id}/sections"
    endpoint "section", "/bibles/{bible_id}/sections/{section_id}"
    endpoint "verses", "/bibles/{bible_id}/chapters/{section_id}/verses"
    endpoint "verse", "/bibles/{bible_id}/verses/{verse_id}"
  end
end
