# frozen_string_literal: true

# Controller for managing programming languages
class ProgrammingLanguageController < ApplicationController
  def index
    @programming_language = DATA
  end

  def search
    search_results = FilterProgrammingLanguageService.new(params[:query]&.downcase).call

    render turbo_stream: turbo_stream.replace('programming_language',
                                              partial: 'programming_language/table',
                                              locals: { programming_language: search_results })
  end
end
