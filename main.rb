class NumberSequenceIterator
  include Enumerable

  attr_reader :input, :sequence_size

  def initialize(input, sequence_size = 4)
    @input = input
    @sequence_size = sequence_size
  end

  def each
    (@input.length - sequence_size + 1).times do |i|
      if (matched_sequence = @input[i, sequence_size].match(/\A\d*\z/))
        yield matched_sequence[0]
      end
    end
  end
end

class MaxMultiplicationFinder
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def find_max_multiplication
    return unless input.is_a?(String)

    number_sequence_iterator.map { |n| n.chars.inject(1) { |memo, number| memo * number.to_i  } }.max
  end

  private

  def number_sequence_iterator
    @number_sequence_iterator ||= NumberSequenceIterator.new(input)
  end
end

describe 'NumberSequenceIterator' do
  subject(:iterator) { NumberSequenceIterator.new(input_string) }
  let (:input_string) { 'sdf03030252221234ывалодывлаоывлдао947984934' }

  it 'iterates by number sequences' do
    expect(iterator.to_a).to eq %w(0303 3030 0302 3025 0252 2522 5222 2221 2212 2123 1234 9479 4798 7984 9849 8493 4934)
  end
end


describe 'Integration tests: MaxMultiplicationFinder' do
  context 'multiplication present' do
    test_strings = {
      'abc12345def' => 120,
      '03030252221234' => 40,
      'sdf03030252221234ывалодывлаоывлдао947984934-двыладлвыадлоыв939854094509069569046ьkjdhsdkfi09348493200234' => 2592
    }

    test_strings.each do |test_string, expected_result|
      it "calculates correct result for #{test_string}" do
        expect(MaxMultiplicationFinder.new(test_string).find_max_multiplication).to eq expected_result
      end
    end
  end

  context 'multiplication absent' do
    let(:test_string) { 'a1b2c3d4e' }

    it 'returns nil' do
      expect(MaxMultiplicationFinder.new(test_string).find_max_multiplication).to eq nil
    end
  end
end

# require 'benchmark'
#
# input = 'sdf03030252221234ывалодывлаоывлдао947984934-двыладлвыадлоыв939854094509069569046ьkjdhsdkfi09348493200234'
# calculator = MaxMultiplicationFinder.new(input)
#
# p Benchmark.measure { 50_000.times { calculator.find_max_multiplication } }.real