class ProgrammingLanguageService
  def initialize(programming_languages)
    @programming_languages = programming_languages
  end

  def filter_programming_languages(search_query)
    positive_query, negative_query = sort_query(search_query)

    if positive_query.present?
      filter_positive(positive_query, negative_query)
    else
      filter_negative(negative_query)
    end
  end

  private

  def sort_query(search_query)
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

  def filter_positive(positive_query, negative_query)
    @programming_languages.filter do |language|
      positive_matches = positive_query.all? do |word|
        language.values.any? { |value| value.to_s.downcase.include?(word) }
      end

      negative_matches = negative_query.any? do |word|
        language.values.any? { |value| value.to_s.downcase.include?(word) }
      end

      positive_matches && !negative_matches
    end
  end

  def filter_negative(negative_query)
    @programming_languages.reject do |language|
      negative_query.any? do |word|
        language.values.any? { |value| value.to_s.downcase.include?(word) }
      end
    end
  end
end
