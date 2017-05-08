xml.instruct!
xml.rss "xmlns:dc"         => "http://purl.org/dc/elements/1.1/",
        "xmlns:sy"         => "http://purl.org/rss/1.0/modules/syndication/",
        "xmlns:admin"      => "http://webns.net/mvcb/",
        "xmlns:atom"       => "http://www.w3.org/2005/Atom/",
        "xmlns:rdf"        => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "xmlns:content"    => "http://purl.org/rss/1.0/modules/content/",
        "xmlns:itunes"     => "http://www.itunes.com/dtds/podcast-1.0.dtd",
        "version"          => "2.0",
        "xmlns:googleplay" => "http://www.google.com/schemas/play-podcasts/1.0" do
  xml.channel do
    xml.title "Sunrise Robot - All Shows"
    xml.link site_url # Link to show page, not a specific episode
    xml.description "All the Sunrise Robot shows!"
    xml.language "en-us"
    xml.copyright "Copyright 2015-#{Time.now.year} Sunrise Robot"
    xml.image do
      xml.url "#{site_url}/images/sunriserobot_album.png"
      xml.title "Sunrise Robot - All Shows"
      xml.link site_url
    end
    # iTunes specific
    xml.tag! "itunes:new-feed-url", "http://sunriserobot.net/all-shows.xml"
    xml.tag! "itunes:subtitle", "Sunrise Robot - All Shows"
    xml.tag! "itunes:author", "Sunrise Robot"
    xml.tag! "itunes:summary", "All the Sunrise Robot shows!"
    xml.tag! "itunes:image href=\"#{site_url}/images/sunriserobot_album.png\""
    xml.tag! "itunes:explicit", "No"
    xml.tag! "itunes:owner" do
      xml.tag! "itunes:name", "Sunrise Robot"
      xml.tag! "itunes:email", "hello@sunriserobot.net"
      end
    xml.tag! "itunes:category", "text" => "Technology" do 
      xml.tag! "itunes:category", "text" => "Tech News" 
    end

  all_episodes = []


  data.shows.each_pair do |show, info|
    blog(data.shows[show]["title"]).articles.each do |episode|
      all_episodes << episode
    end
  end

  all_episodes.sort! { |a, b| b.data.pubDate <=> a.data.pubDate }

  # Item builder
  all_episodes.each do |episode|
    xml.item do
    link = URI.join(site_url, episode.url)
      xml.title "#{episode.blog_controller.name} ##{episode.data.number} - #{episode.data.title}"
      xml.link link
      xml.guid link
      xml.pubDate episode.date.strftime("%a, %d %b %Y 09:00:00 GMT")
      xml.author hosts(data.shows[episode.blog_controller.options.prefix.gsub("/", "")])
      xml.description episode.data.description
      xml.enclosure "url" => episode.data.enclosure_link,
                    "length" => episode.data.enclosure_length,
                    "type" => "audio/mpeg"
      xml.tag! "content:encoded",
               "<p>#{episode.data.description}</p>"\
               "<h1>Show Notes</h1>"\
               "#{episode.body}"\
               "\n#{rss_boilerplate(data.shows[episode.blog_controller.options.prefix.gsub("/", "")], episode)}"
      xml.tag! "itunes:author", hosts(data.shows[episode.blog_controller.options.prefix.gsub("/", "")])
      xml.tag! "itunes:duration", episode.data.duration
      xml.tag! "itunes:subtitle", episode.data.description
      xml.tag! "itunes:summary", episode.data.description
      xml.tag! "itunes:image", "href" => "#{site_url}/images/#{data.shows[episode.blog_controller.options.prefix.gsub("/", "")]["large_art"]}"
    end
  end
  end
end
