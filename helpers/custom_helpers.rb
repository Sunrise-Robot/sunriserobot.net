module CustomHelpers
  def site_url
    "http://sunriserobot.net"
  end

  def page_title
    if current_article
      episode_title
    elsif @show
      show_title
    else
      default_title
    end
  end

  def default_title
    "Sunrise Robot | Podcasts for technologists, gamers, artists and cultural enthusiasts"
  end

  def show_title
    "#{@show["title"]} | #{default_title}"
  end

  def episode_title
   "#{@show["title"]} ##{current_article.data.number}: #{current_article.title} | #{default_title}" 
  end

  def page_description
    if current_article
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
end
