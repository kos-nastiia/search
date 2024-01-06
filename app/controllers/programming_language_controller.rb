class ProgrammingLanguageController < ApplicationController
  def index
    @programming_language = DATA
  end

  def search
    @programming_languages = DATA
    search_query = params[:query]&.downcase
    
    positive_query, negative_query = sort_query(search_query)
    
    @search_results = filter_programming_languages(positive_query, negative_query)
    
    render turbo_stream: turbo_stream.replace("programming_language",
      partial: "programming_language/table",
      locals: { programming_language: @search_results }
    )
  end

  private

  def sort_query(search_query) # determine whether the request was positive or negative
    positive_query = []
    negative_query = []

    search_query&.split&.each do |word|
      if word.start_with?('-')
        negative_query << word.slice(1..-1)
      else
        positive_query << word
      end
    end

    [positive_query, negative_query]
  end

  def filter_programming_languages(positive_query, negative_query) # choose the required language depending on the input
    if positive_query.present?
      @programming_languages.filter do |language|
        positive_matches = positive_query.all? do |word|
          language.values.any? { |value| value.to_s.downcase.include?(word) }
        end
  
        negative_matches = negative_query.any? do |word|
          language.values.any? { |value| value.to_s.downcase.include?(word) }
        end
  
        positive_matches && !negative_matches
      end
    else
      @programming_languages.reject do |language|
        negative_query.any? do |word|
          language.values.any? { |value| value.to_s.downcase.include?(word) }
        end
      end
    end

  end

end
