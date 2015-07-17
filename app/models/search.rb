class Search < ActiveRecord::Base
  include ViewersHelper

  has_many :includes_topics, through: :including_topics, source: :topic
  has_many :excludes_topics, through: :excluding_topics, source: :topic
  has_many :viewers,         through: :excluding_viewers
  has_many :including_topics
  has_many :excluding_topics
  has_many :excluding_viewers
  validates_numericality_of :min_speaks, greater_than_or_equal_to: 44,
                            less_than_or_equal_to: 56,
                            allow_blank: true
  validates_numericality_of :min_wins, greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100,
                            allow_blank: true
  validates_numericality_of :min_tight_call, greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100,
                            allow_blank: true
  validates_numericality_of :max_tight_call, greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100,
                            allow_blank: true
  attr_reader :excluding_viewers_list, :excluding_topics_list,
              :including_topics_list

  def excluding_viewers_list
    self.viewers.map(&:name).join(", ")
  end

  def excluding_viewers_list=(names)
    self.viewers.clear
    names.split(',').each do |name|
      viewer = Viewer.find_by_name(format_name(name.strip))
      self.viewers << viewer if viewer
    end
  end

  def excluding_topics_list
    self.excludes_topics.map(&:name).join(", ")
  end

  def excluding_topics_list=(names)
    self.excludes_topics.clear
    names.split(',').each do |name|
      topic = Topic.find_by_name(name.downcase.strip)
      self.excludes_topics << topic if topic
    end
  end

  def including_topics_list
    self.includes_topics.map(&:name).join(", ")
  end

  def including_topics_list=(names)
    self.includes_topics.clear
    names.split(',').each do |name|
      topic = Topic.find_by_name(name.downcase.strip)
      self.includes_topics << topic if topic
    end
  end

  def search_cases
    cases = Case.all

    cases = cases.where("title LIKE ? OR case_statement LIKE ?", "%#{keywords}%", "%#{keywords}%") if keywords.present?
    cases = cases.where("average_speaks >= ?", min_speaks) if min_speaks.present?
    cases = cases.where("win_percentage >= ?", min_wins) if min_wins.present?
    cases = cases.where("tight_call_percentage <= ?", max_tight_call) if max_tight_call.present?
    cases = cases.where("tight_call_percentage >= ?", max_tight_call) if min_tight_call.present?
    ids = includes_topics.pluck(:id)
      cases = cases.includes(:topics).where('topics.id' => ids) if including_topics.present?
      ids = excludes_topics.pluck(:id)
      included_cases_ids = Case.all.includes(:topics).where(
                           'topics.id' => ids).pluck(:id)
      cases = cases.where.not('id' => included_cases_ids) if excluding_topics.present?
      ids = viewers.pluck(:id)
      included_viewers = Case.all.includes(:viewers).where(
                        'viewers.id' => ids).pluck(:id)
      cases = cases.where.not('id' => included_viewers) if excluding_viewers.present?
    cases
  end
end
