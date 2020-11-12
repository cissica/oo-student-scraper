require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
      page = Nokogiri::HTML(open(index_url))
      students = []

      page.css("div.student-card").each do |card|
        name = card.css("h4.student-name").text
        location = card.css("p.student-location").text
        profile_url = card.css("a").attribute("href").value
        info = {:name => name, 
          :location => location,
          :profile_url => profile_url}
        students << info 
      end 
      students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    student = {}
    container = page.css("div.social-icon-container a").collect do |container| 
    container.attribute("href").value
    end 
    container.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?(".com")
        student[:blog] = link
      end 
    end 
    #binding.pry
    student[:profile_quote] = page.css("div.profile-quote").text
    student[:bio] = page.css("div.description-holder p").text
    student
  end 

end

