class BibleApi < ApiEngine
  def initialize(**options)
    url = "https://api.scripture.api.bible/v1"
    options[:query_interval] = 10
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
    endpoint "books", path:"/bibles/{bible_id}/books"
    endpoint "chapters", path:"/bibles/{bible_id}/books/{book_id}/chapters"
    endpoint "passage", path:"/bibles/{bible_id}/passages/{passage_id}"
    endpoint "sections", path:"/bibles/{bible_id}/{range_type}/{range_id}/sections"
    endpoint "section", path:"/bibles/{bible_id}/sections/{section_id}"
    endpoint "verses", path:"/bibles/{bible_id}/chapters/{chapter_id}/verses"
    endpoint "verse", path:"/bibles/{bible_id}/verses/{verse_id}"
  end
  def range_types
    return [["Book","book"],["Chapter","chapter"],["Verse","verse"]]
  end
end
