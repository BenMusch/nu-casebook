require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = Topic.new(name: "testing")
  end

  test "names are created" do
    assert_equal @topic.name, "testing"
    @topic.save
    saved_topic = Topic.find_by_name("testing")
    assert_not_nil saved_topic
  end
end
