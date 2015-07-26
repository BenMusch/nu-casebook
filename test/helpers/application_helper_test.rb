class ApplicationHelperTest < ActionView::TestCase

  test "map with id" do
    assert_equal Case.all.collect { |c| [c.title, c.id]}, map_with_id(Case, :title)
  end
end
