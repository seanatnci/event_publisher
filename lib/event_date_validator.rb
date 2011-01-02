class EventDateValidator < ActiveModel::Validator

  def validate(record)
    # only check if not nil
    return if (record.date.nil? || record.end_date.nil?)
    record.errors[:base] << "Start Date After End Date" if check_dates(record)
    record.errors[:base] << "Start Date Must Be Today or Greater" if check_date_valid(record.date)
    record.errors[:base] << "End Date Must Be Today or Greater" if check_date_valid(record.end_date)
  end

  private

  def check_dates(record)
    record.date > record.end_date
  end

  def check_date_valid(date)
    date < Date.today
  end

end
