require 'test_helper'

class CaseTest < ActiveSupport::TestCase

  def setup
    @case = Case.new(link: "http://www.drive.google.com",
                     title: "Abolish sex",
                     case_statement: "This house would abolish sex",
                     created_at: Time.zone.now,
                     opp_choice: false)
    @one = cases(:one)
    @two = cases(:two)
    @three = cases(:three)
    @four = cases(:four)
    @five = cases(:five)
    @six = cases(:six)
    @seven = cases(:seven)
  end

  test "link accepts valid links" do
    valid_links = %w[http://www.google.com
                     https://www.google.com
                     http://www.google.com/heres-a_Link.pdf
                     http://www.google.net/An0th3r.li"nk?]
    valid_links.each do |valid_link|
      @case.link = valid_link
      assert @case.valid?, "#{valid_link} should be valid"
    end
  end

  test "link rejects invalid links" do
    invalid_links = [#'http://www.goo gle.com',
                     'ht://www.google.com/heres-a_Link.pdf',
                     'not-a-link',
                     '                   ']
    invalid_links.each do |invalid_link|
      @case.link = invalid_link
      assert_not @case.valid?, "#{invalid_link} should be invalid"
    end
  end

  test "rejects blank titles" do
    @case.title = "   "
    assert_not @case.valid?
  end

  test "rejects titles that are too long" do
    @case.title = "a" * 101
    assert_not @case.valid?
  end

  test "rejects blank case statements" do
    @case.case_statement = "  "
    assert_not @case.valid?
  end

  test "accepts valid cases" do
    assert @case.valid?
  end
end
