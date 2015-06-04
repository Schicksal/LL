require 'open-uri'
require 'json'
require 'mechanize'

class GetPics
  def initialize
    @word
  end

  # Search Google for the word
  def search
    agent = Mechanize.new do |a|
      a.user_agent_alias = "Linux Firefox"
    end

    gform = agent.get("http://google.com/images").form("f")
    gform.q = @word
    return agent.submit(gform, gform.buttons.first)
  end

  # Get the images from the page
  def parse(page)
    return page.images
  end

  # Generate html from the images
  def genHTML(imagelist)
    html = ""
    count = 1

    # Add all images to html
    imagelist.each do |image|
      html += '<img src="'+image.to_s+'" />  '

      # Add spacing every 5 pictures
      html += '<br /><br />' if count%5 == 0
      count += 1
    end

    return html
  end

  # Run search and get results for new word
  def getResults(word)
    @word = word
    return parse(search)
  end

  # Get many different results
  def loopCall
    search_term = "search"

    # Keep running until someone submits an empty term
    while !search_term.empty?
      print "Enter Search Term: "
      search_term = gets.chomp
      search_results = getResults(search_term)
      File.write("images.html", genHTML(search_results))
    end
  end
end

g = GetPics.new
puts g.loopCall
