class NotSethValidator < ActiveModel::EachValidator
  def validate_each(person, attribute, value)
    if value == 'goldstein.se@husky.neu.edu'
      person.errors[:base] << "Nice try, Seth."
    elsif !(value =~ /\A[A-Za-z\-]+\.\w+@husky.neu.edu/i)
      person.errors[attribute] << "is not a @husky.neu.edu address"
    end
  end
end
