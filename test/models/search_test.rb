require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  def setup
    @search = Search.new
  end

  test "accepts blank searches" do
    assert @search.valid?
  end

  test "rejects invalid min_speaks" do
    invalid_values = [57, 43, "not a number"]
    invalid_values.each do |value|
      @search.min_speaks = value
      assert_not @search.valid?
    end
  end

  test "rejects invalid min_wins" do
    invalid_values = [-1, 101, "not a number"]
    invalid_values.each do |value|
      @search.min_speaks = value
      assert_not @search.valid?
    end
  end

  test "rejects invalid max_tight_call" do
    invalid_values = [-1, 101, "not a number"]
    invalid_values.each do |value|
      @search.min_speaks = value
      assert_not @search.valid?
    end
  end

  test "rejects invalid min_tight_call" do
    invalid_values = [-1, 101, "not a number"]
    invalid_values.each do |value|
      @search.min_speaks = value
      assert_not @search.valid?
    end
  end
end
