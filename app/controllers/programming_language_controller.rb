class ProgrammingLanguageController < ApplicationController
  def index
    @programming_language = DATA
  end

  def search
    @programming_languages = DATA
        
    if params[:query].present?
      search_query = params[:query].downcase

      positive_query = []
      negative_query = []

      search_query.split.each do |word|
        if word.start_with?('-')
          negative_query << word.slice(0)
        else
          positive_query << word
        end
      end
      
      @search_results = @programming_languages.filter do |language|
        positive_matches = positive_query.all? do |word|
          language.values.any? { |value| value.to_s.downcase.include?(word) }
        end
  
        negative_matches = negative_query.any? do |word|
          language.values.any? { |value| value.to_s.downcase.include?(word) }
        end
  
        positive_matches && !negative_matches
      end
    else
      @search_results = @programming_languages
    end
    
    render turbo_stream: turbo_stream.replace("programming_language",
      partial: "programming_language/table",
      locals: { programming_language: @search_results }
    )
  end
  
end
