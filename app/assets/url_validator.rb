class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.include?(' ')
      record.errors[attribute] << "can't can't have spaces"
    elsif !(value =~ /https?:\/\/[\S]+/i)
      message = "must be a valid URL starting with http:// or https://"
      record.errors[attribute] << message
    end
  end
end
