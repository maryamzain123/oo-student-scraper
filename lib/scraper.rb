require 'nokogiri'
require 'open-uri'
require 'pry'


class Scraper 
  
  def self.scrape_index_page(index_url)
    scraped_students = []
    @doc = Nokogiri::HTML(open(index_url))
    @doc.css("div.roster-cards-container").each do |card|
      card.css("div.student-card").each do |student|
      student_name = student.css("h4.student-name").text
      location_name = student.css("p.student-location").text
      url = student.css("a").attr('href').value
      
      scraped_students << {name:student_name, location:location_name, profile_url:url}
      end
    end
    scraped_students
  end



  def self.scrape_profile_page(profile_url)
    @doc = Nokogiri::HTML(open(profile_url))
    scraped_profiles = {}
    social_links = @doc.css(".social-icon-container").css("a").map do |link|
      link.attr("href")
    
    end

    social_links.each do |link|
      if link.include?("twitter")
        scraped_profiles[:twitter] = link
      elsif link.include?("linkedin")
        scraped_profiles[:linkedin] = link
      elsif link.include?("github")
        scraped_profiles[:github] = link
      else 
        scraped_profiles[:blog] = link
      end
    end

    scraped_profiles[:profile_quote] = @doc.css(".profile-quote").text if @doc.css(".profile-quote")
    scraped_profiles[:bio] = @doc.css("div.description-holder").css("p").text if @doc.css("div.description-holder")
    scraped_profiles
    


    
    
  end

end

