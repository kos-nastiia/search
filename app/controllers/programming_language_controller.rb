class ProgrammingLanguageController < ApplicationController
  def index
    @programming_language = DATA
  end

  def search
    @programming_languages = DATA

  if params[:query].present?
    @search_results = @programming_languages.select do |language|
      language[:Name].downcase.include?(params[:query].downcase)
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
