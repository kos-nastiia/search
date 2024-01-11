# frozen_string_literal: true

# Controller for managing programming languages
class ProgrammingLanguageController < ApplicationController
  def index
    @programming_language = DATA
  end

  def search
    @programming_languages = DATA
    search_query = params[:query]&.downcase

    filter_service = ProgrammingLanguageService.new(@programming_languages)
    @search_results = filter_service.filter_programming_languages(search_query)

    render turbo_stream: turbo_stream.replace('programming_language',
                                              partial: 'programming_language/table',
                                              locals: { programming_language: @search_results })
  end
end
