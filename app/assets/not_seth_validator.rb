class NotSethValidator < ActiveModel::EachValidator
  def validate_each(person, attribute, value)
    if value == 'goldstein.se@husky.neu.edu'
      person.errors[attribute] << "can't belong to a traitor. Nice try, Seth."
    elsif !(value =~ /\A(\w)+\.(\w)+@husky.neu.edu/i)
      person.errors[attribute] << "is not a @husky.neu.edu address"
    end
  end
end
