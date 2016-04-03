---
blog: "The Pseudo Show"
---
@show_data       = data.shows[blog.options.prefix.sub("/", "")]
@rss_boilerplate = YAML.load_file("data/rss-boilerplate.yml")["rss_boilerplate"]
@host_names      = @show_data["hosts"].map { |host| host["name"] }.join(" and ")
@album_art_url   = "http://sunriserobot.net/images/#{@show_data["large_art"]}"
