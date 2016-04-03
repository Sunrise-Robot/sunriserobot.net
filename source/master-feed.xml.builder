xml.instruct!
xml.rss "xmlns:dc"      => "http://purl.org/dc/elements/1.1/",
        "xmlns:sy"      => "http://purl.org/rss/1.0/modules/syndication/",
        "xmlns:admin"   => "http://webns.net/mvcb/",
        "xmlns:atom"    => "http://www.w3.org/2005/Atom/",
        "xmlns:rdf"     => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
        "xmlns:itunes"  => "http://www.itunes.com/dtds/podcast-1.0.dtd",
        "version"       => "2.0" do
  xml.channel do
    site_url = "http://sunriserobot.net"
    xml.title "Sunrise Robot Master Feed"
    xml.link site_url # Link to show page, not a specific episode
    xml.description "All the Sunrise Robot shows!"
    xml.language "en-us"
    xml.copyright "Copyright 2015-#{Time.now.year} Sunrise Robot"
    xml.image do
      xml.url "" # TODO: Fix this
      xml.title "Sunrise Robot Master Feed" # TODO: Fix this
      xml.link site_url
    end
    # iTunes specific
    xml.tag! "itunes:new-feed-url", "http://sunriserobot.net/master-feed.xml"
    xml.tag! "itunes:subtitle", "Sunrise Robot Master Feed"
    xml.tag! "itunes:author", "Sunrise Robot"
    xml.tag! "itunes:summary", "All the Sunrise Robot shows!"
    xml.tag! "itunes:image href=\"\"" # TODO: Fix this
    xml.tag! "itunes:explicit", "No"
    xml.tag! "itunes:owner" do
      xml.tag! "itunes:name", "Sunrise Robot"
      xml.tag! "itunes:email", "hello@sunriserobot.net"
      end
    xml.tag! "itunes:category", "text" => "Technology" do 
      xml.tag! "itunes:category", "text" => "Tech News" 
    end
  end

  all_episodes = []


  data.shows.each_pair do |show, info|
    blog(data.shows[show]["title"]).articles[0..9].each do |episode|
      all_episodes << episode
    end
  end

  all_episodes.sort! { |a, b| b.data.pubDate <=> a.data.pubDate }

  # Item builder
  all_episodes.each do |episode|
    xml.item do
    link = URI.join(site_url, episode.url)
      xml.title "#{episode.data.number} - #{episode.data.title}"
      xml.link link
      xml.guid link
      xml.pubDate episode.date.strftime("%a, %d %b %Y 09:00:00 GMT")
      xml.author "" # TODO: Fix author
      xml.description episode.data.description
      xml.enclosure "url" => episode.data.enclosure_link,
                    "length" => episode.data.enclosure_length,
                    "type" => "audio/mpeg"
      xml.tag! "content:encoded",
               "<p>#{episode.data.description}</p>"\
               "<h1>Show Notes</h1>"\
               "#{episode.body}"\
               "\n#{rss_boilerplate(data.shows[episode.blog_controller.options.prefix.gsub("/", "")], episode)}" # TODO: Show data needs to get to this method somehow
      xml.tag! "itunes:author", "" # TODO: Fix host names
      xml.tag! "itunes:duration", episode.data.duration
      xml.tag! "itunes:subtitle", episode.data.description
      xml.tag! "itunes:summary", episode.data.description
      xml.tag! "itunes:image", "href" => "" # TODO: Fix album art
    end
  end
end

