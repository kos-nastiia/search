# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilterProgrammingLanguageService, type: :service do
  let(:programming_languages_data) { DATA }

  describe '#filter_programming_languages' do
    it 'returns all programming languages when no query is provided' do
      result = FilterProgrammingLanguageService.new(nil).call
      expect(result).to match_array(programming_languages_data)
    end

    it 'matches a programming language named "Common Lisp" with search query "Lisp Common"' do
      search_query = 'Lisp Common'
      result = FilterProgrammingLanguageService.new(search_query.downcase).call

      expected_result = [
        {
          'Name' => 'Common Lisp',
          'Type' => 'Compiled, Interactive mode, Object-oriented class-based, Reflective',
          'Designed by' => 'Scott Fahlman, Richard P. Gabriel, Dave Moon, Guy Steele, Dan Weinreb'
        }
      ]

      result_symbol_keys = result.map { |h| h.transform_keys(&:to_s) }

      expect(result_symbol_keys).to eq(expected_result)
    end

    it 'supports exact matches, e.g. Interpreted Thomas Eugene' do
      search_query = 'Interpreted Thomas Eugene'
      result = FilterProgrammingLanguageService.new(search_query.downcase).call

      expected_result = {
        'Name' => 'BASIC',
        'Type' => 'Imperative, Compiled, Procedural, Interactive mode, Interpreted',
        'Designed by' => 'John George Kemeny, Thomas Eugene Kurtz'
      }

      result_symbol_keys = result.map { |h| h.transform_keys(&:to_s) }

      expect(result_symbol_keys).to eq([expected_result])
    end

    it 'supports exact not matches, e.g. Interpreted Thomas Eugene' do
      search_query = 'Interpreted Thomas Eugene'
      result = FilterProgrammingLanguageService.new(search_query.downcase).call

      not_expected_result = {
        "Name": 'Haskell',
        "Type": 'Compiled, Functional, Metaprogramming, Interpreted, Interactive mode',
        "Designed by": 'Simon Peyton Jones, Lennart Augustsson, Dave Barton, Brian Boutel, Warren Burton, Joseph Fasel, Kevin Hammond, Ralf Hinze, Paul Hudak, John Hughes, Thomas Johnsson, Mark Jones, John Launchbury, Erik Meijer, John Peterson, Alastair Reid, Colin Runciman, Philip Wadler'
      }

      result_symbol_keys = result.map { |h| h.transform_keys(&:to_s) }

      expect(result_symbol_keys).not_to eq([not_expected_result])
    end

    it 'matches in different fields, e.g. Scripting Microsoft' do
      search_query = 'Scripting Microsoft'
      result = FilterProgrammingLanguageService.new(search_query.downcase).call

      expected_result = [
        {
          'Name' => 'JScript',
          'Type' => 'Curly-bracket, Procedural, Reflective, Scripting',
          'Designed by' => 'Microsoft'
        },
        {
          'Name' => 'VBScript',
          'Type' => 'Interpreted, Procedural, Scripting, Object-oriented class-based',
          'Designed by' => 'Microsoft'
        },
        {
          'Name' => 'Windows PowerShell',
          'Type' => 'Command line interface, Curly-bracket, Interactive mode, Interpreted, Scripting',
          'Designed by' => 'Microsoft'
        }
      ]

      result_symbol_keys = result.map { |h| h.transform_keys(&:to_s) }

      expect(result_symbol_keys).to eq(expected_result)
    end

    it 'support for negative searches, eg. john -array matches' do
      search_query = 'john -array'
      result = FilterProgrammingLanguageService.new(search_query.downcase).call

      expected_result = [
        {
          'Name' => 'BASIC',
          'Type' => 'Imperative, Compiled, Procedural, Interactive mode, Interpreted',
          'Designed by' => 'John George Kemeny, Thomas Eugene Kurtz'
        },
        {
          'Name' => 'Haskell',
          'Type' => 'Compiled, Functional, Metaprogramming, Interpreted, Interactive mode',
          'Designed by' => 'Simon Peyton Jones, Lennart Augustsson, Dave Barton, Brian Boutel, Warren Burton, Joseph Fasel, Kevin Hammond, Ralf Hinze, Paul Hudak, John Hughes, Thomas Johnsson, Mark Jones, John Launchbury, Erik Meijer, John Peterson, Alastair Reid, Colin Runciman, Philip Wadler'
        },
        {
          'Name' => 'Lisp',
          'Type' => 'Metaprogramming, Reflective',
          'Designed by' => 'John McCarthy'
        },
        {
          'Name' => 'S-Lang',
          'Type' => 'Curly-bracket, Interpreted, Procedural, Scripting, Interactive mode',
          'Designed by' => 'John E. Davis'
        }
      ]

      result_symbol_keys = result.map { |h| h.transform_keys(&:to_s) }

      expect(result_symbol_keys).to eq(expected_result)
    end

    it 'support for negative searches, eg. john -array not matches' do
      search_query = 'john -array'
      result = FilterProgrammingLanguageService.new(search_query.downcase).call

      expected_result = [
        {
          'Name' => 'Chapel',
          'Type' => 'Array',
          'Designed by' => 'David Callahan, Hans Zima, Brad Chamberlain, John Plevyak'
        },
        {
          'Name' => 'Fortran',
          'Type' => 'Array, Compiled, Imperative, Procedural',
          'Designed by' => 'John Backus'
        },
        {
          'Name' => 'S',
          'Type' => 'Array',
          'Designed by' => 'Rick Becker, Allan Wilks, John Chambers'
        }
      ]

      result_symbol_keys = result.map { |h| h.transform_keys(&:to_s) }

      expect(result_symbol_keys).not_to eq(expected_result)
    end
  end
end
