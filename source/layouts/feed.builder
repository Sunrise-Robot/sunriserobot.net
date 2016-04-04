current_show = blog.options.prefix.gsub("/", "")
@show = data.shows[current_show]

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
    show_url = "#{site_url}/#{@show["stub"]}"
    xml.title @show["title"]
    xml.link show_url # Link to show page, not a specific episode
    xml.description @show["description"]
    xml.language "en-us"
    xml.copyright "Copyright 2015-#{Time.now.year} Sunrise Robot"
    xml.image do
      xml.url "#{site_url}/images/#{@show["large_art"]}"
      xml.title @show["title"]
      xml.link show_url
    end
    # iTunes specific
    xml.tag! "itunes:new-feed-url", "http://sunriserobot.net/#{@show["stub"]}/feed.xml"
    xml.tag! "itunes:subtitle", @show["title"]
    xml.tag! "itunes:author", "Sunrise Robot"
    xml.tag! "itunes:summary", @show["description"]
    xml.tag! "itunes:image href=\"#{site_url}/images/#{@show["large_art"]}\""
    xml.tag! "itunes:explicit", "No"
    xml.tag! "itunes:owner" do
      xml.tag! "itunes:name", "Sunrise Robot"
      xml.tag! "itunes:email", @show["email"]
    end
    @show["categories"].each do |category|
      if category["subcategory"]
        xml.tag! "itunes:category", "text" => category["category"] do
          xml.tag! "itunes:category", "text" => category["subcategory"]
        end
      else
        xml.tag! "itunes:category", "text" => category["category"]
      end
    end

    # Item builder
    blog.articles.each do |episode|
      xml.item do
      link = URI.join(site_url, episode.url)
        xml.title "#{episode.data.number} - #{episode.data.title}"
        xml.link link
        xml.guid link
        xml.pubDate episode.date.strftime("%a, %d %b %Y 09:00:00 GMT")
        xml.author hosts(@show)
        xml.description episode.data.description
        xml.enclosure "url" => episode.data.enclosure_link,
                      "length" => episode.data.enclosure_length,
                      "type" => "audio/mpeg"
        xml.tag! "content:encoded",
                 "<p>#{episode.data.description}</p>"\
                 "<h1>Show Notes</h1>"\
                 "#{episode.body}"\
                 "\n#{rss_boilerplate(@show, episode)}"
        xml.tag! "itunes:author", hosts(@show)
        xml.tag! "itunes:duration", episode.data.duration
        xml.tag! "itunes:subtitle", episode.data.description
        xml.tag! "itunes:summary", episode.data.description
        xml.tag! "itunes:image", "href" => "#{site_url}/images/#{@show["large_art"]}"
      end
    end
  end
end
