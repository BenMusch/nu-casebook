class Search < ActiveRecord::Base
  include Helpers

  attr_reader :excluding_viewers_list, :excluding_topics_list,
              :including_topics_list

  has_many :includes_topics, through: :including_topics, source: :topic
  has_many :excludes_topics, through: :excluding_topics, source: :topic
  has_many :viewers,         through: :excluding_viewers
  has_many :including_topics
  has_many :excluding_topics
  has_many :excluding_viewers

  validates :min_speaks, numericality: { greater_than_or_equal_to: 44,
                                         less_than_or_equal_to: 56,
                                         allow_blank: true }
  validates :min_wins, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 100,
                                       allow_blank: true }
  validates :min_tight_call, numericality: { greater_than_or_equal_to: 0,
                                             less_than_or_equal_to: 100,
                                             allow_blank: true }
  validates :max_tight_call, numericality: { greater_than_or_equal_to: 0,
                                             less_than_or_equal_to: 100,
                                             allow_blank: true }

  # Returns a comma-separated string of the Viewers for this Search
  def excluding_viewers_list
    names_string(self.viewers)
  end

  # Sets the Viewers of this case equal to the comma-separated list of names
  def excluding_viewers_list=(names)
    self.viewers.clear
    names.split(',').each do |name|
      viewer = Viewer.find_by_name(format_name(name.strip))
      self.viewers << viewer if viewer
    end
  end

  # Comma-separated list of the Topics this Search excludes
  def excluding_topics_list
    names_string(self.excludes_topics)
  end

  # Sets the excluded Topics of this Search as the comma-separated list of names
  def excluding_topics_list=(names)
    self.excludes_topics.clear
    names.split(',').each do |name|
      topic = Topic.find_by_name(name.downcase.strip)
      self.excludes_topics << topic if topic
    end
  end

  # Comma-separated list of the Topics this Search includes
  def including_topics_list
    names_string(self.includes_topics)
  end

  # Sets the included Topics of this Search as the comma-separated list of names
  def including_topics_list=(names)
    self.includes_topics.clear
    names.split(',').each do |name|
      topic = Topic.find_by_name(name.downcase.strip)
      self.includes_topics << topic if topic
    end
  end

  def search_cases
    cases = Case.all
    # Keywords
    cases = cases.where("title LIKE ? OR case_statement LIKE ?",
                        "%#{keywords}%", "%#{keywords}%") if keywords.present?
    # Min speaks
    cases = cases.where("average_speaks >= ?",
                        min_speaks) if min_speaks.present?
    # Min wins
    cases = cases.where("win_percentage >= ?", min_wins) if min_wins.present?
    # Max tight call
    cases = cases.where("tight_call_percentage <= ?",
                        max_tight_call) if max_tight_call.present?
    # Min tight call
    cases = cases.where("tight_call_percentage >= ?",
                        max_tight_call) if min_tight_call.present?
    # Includes topics
    ids = includes_topics.pluck(:id)
    cases = cases.includes(:topics)
            .where('topics.id' => ids) if including_topics.present?
    # Excludes topics
    ids = excludes_topics.pluck(:id)
    included_cases_ids = Case.all.includes(:topics).where(
                         'topics.id' => ids).pluck(:id)
    cases = cases.where
            .not('id' => included_cases_ids) if excluding_topics.present?
    # Excludes viewers
    ids = viewers.pluck(:id)
    included_viewers = Case.all.includes(:viewers).where(
                      'viewers.id' => ids).pluck(:id)
    cases = cases.where
            .not('id' => included_viewers) if excluding_viewers.present?
    # Final relation
    cases
  end
end
