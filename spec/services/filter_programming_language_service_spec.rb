# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilterProgrammingLanguageService, type: :service do
  let(:search) { nil }
  let(:expected_result) { DATA }
  let(:not_expected_result) { DATA }

  subject(:service_call) { FilterProgrammingLanguageService.new(search.downcase).call }

  describe '#filter_programming_languages' do
    context 'list of languages' do
      subject(:service_call) { FilterProgrammingLanguageService.new(search).call }

      it 'returns all programming languages when no query is provided' do
        expect(service_call).to match_array(expected_result)
      end
    end

    context 'when search with replacing' do
      let(:search) { 'Lisp Common' }
      let(:expected_result) do
        [
          {
            'Name' => 'Common Lisp',
            'Type' => 'Compiled, Interactive mode, Object-oriented class-based, Reflective',
            'Designed by' => 'Scott Fahlman, Richard P. Gabriel, Dave Moon, Guy Steele, Dan Weinreb'
          }
        ]
      end

      it 'matches a programming language named "Common Lisp" with search query "Lisp Common"' do
        result_symbol_keys = service_call.map { |h| h.transform_keys(&:to_s) }

        expect(result_symbol_keys).to eq(expected_result)
      end
    end

    context 'exact search' do
      let(:search) { 'Interpreted Thomas Eugene' }
      let(:expected_result) do
        {
          'Name' => 'BASIC',
          'Type' => 'Imperative, Compiled, Procedural, Interactive mode, Interpreted',
          'Designed by' => 'John George Kemeny, Thomas Eugene Kurtz'
        }
      end
      let(:not_expected_result) do
        {
          "Name": 'Haskell',
          "Type": 'Compiled, Functional, Metaprogramming, Interpreted, Interactive mode',
          "Designed by": 'Simon Peyton Jones, Lennart Augustsson, Dave Barton, Brian Boutel, Warren Burton, Joseph Fasel, Kevin Hammond, Ralf Hinze, Paul Hudak, John Hughes, Thomas Johnsson, Mark Jones, John Launchbury, Erik Meijer, John Peterson, Alastair Reid, Colin Runciman, Philip Wadler'
        }
      end

      it 'supports exact matches, e.g. Interpreted Thomas Eugene' do
        result_symbol_keys = service_call.map { |h| h.transform_keys(&:to_s) }

        expect(result_symbol_keys).to eq([expected_result])
      end

      it 'supports exact not matches, e.g. Interpreted Thomas Eugene' do
        result_symbol_keys = service_call.map { |h| h.transform_keys(&:to_s) }

        expect(result_symbol_keys).not_to eq([not_expected_result])
      end
    end

    context 'search by different fields' do
      let(:search) { 'Scripting Microsoft' }
      let(:expected_result) do
        [
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
      end

      it 'matches in different fields, e.g. Scripting Microsoft' do
        result_symbol_keys = service_call.map { |h| h.transform_keys(&:to_s) }

        expect(result_symbol_keys).to eq(expected_result)
      end
    end

    context 'negative search' do
      let(:search) { 'john -array' }
      let(:expected_result) do
        [
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
      end
      let(:not_expected_result) do
        [
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
      end

      it 'support for negative searches, eg. john -array matches' do
        result_symbol_keys = service_call.map { |h| h.transform_keys(&:to_s) }

        expect(result_symbol_keys).to eq(expected_result)
      end

      it 'support for negative searches, eg. john -array not matches' do
        result_symbol_keys = service_call.map { |h| h.transform_keys(&:to_s) }

        expect(result_symbol_keys).not_to eq(not_expected_result)
      end
    end
  end
end
