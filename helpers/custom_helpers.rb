module CustomHelpers
  def site_url
    "http://sunriserobot.net"
  end

  def current_blog
    name = nil
    data.shows.each_pair do |show, info|
      name = data.shows[show]["title"] if current_page.url.match(/#{data.shows[show]["stub"]}/)
    end

    blog(name)
  end

  def page_title
    if current_article && !(blog.options.name == "blog")
      episode_title
    elsif @show
      show_title
    elsif current_article && (blog.options.name == "blog")
      "#{current_page.data.title} | #{blog_title}"
    else
      "#{current_page.data.title}"
    end
  end

  def show_title
    "#{@show["title"]} | Sunrise Robot"
  end

  def episode_title
   "#{@show["title"]} ##{current_article.data.number}: #{current_article.title} | Sunrise Robot"
  end

  def blog_title
    "H3LiOS' Log: the Sunrise Robot blog"
  end

  def page_description
    if current_article && !(blog.options.name == "blog")
      episode_description
    elsif @show
      show_description
    else
      "Sunrise Robot | Podcasts for technologists, gamers, artists and cultural enthusiasts."
    end
  end

  def show_description
    @show["description"]
  end

  def episode_description
    current_article.data.description
  end

  def page_image
    if @show
      "#{site_url}/images/#{@show["social_art"]}"
    else
      "#{site_url}/images/sunriserobot_social.png"
    end
  end

  def rss_boilerplate(show, episode)
   data.rss_boilerplate["rss_boilerplate"] % { :LINK => "#{site_url}#{episode.url}",
                            :SHOW_TITLE => show["title"],
                            :SHOW_HOSTS => hosts(show), # TODO: Fix host names
                            :ITUNES_LINK => show["itunes"] }
  end

  def hosts(show)
   show["hosts"].map { |host| host["name"] }.join(" and ")
  end
end
