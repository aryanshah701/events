defmodule EventsWeb.ControllerHelpers do
  def format_event_params(event_params) do 
    new_params = %{event_params | "date" => parse_datetime(event_params["date"]) }
    IO.inspect new_params
    new_params
  end

  def parse_datetime(str_date) do
    # Split string to get the date and time
    datetime_info = String.split(str_date)
    date = Enum.at(datetime_info, 0)
    time = Enum.at(datetime_info, 1)
    suffix = Enum.at(datetime_info, 2)

    # Get the year, month, and day
    {year, month, day} = parse_date(date)

    # Get the 24 hour, minute, second
    {hour, minute, second} = parse_time(time, suffix)

    # Create the datetime object
    {:ok, datetime} = NaiveDateTime.new(year, month, day, hour, minute, second)
    
    datetime
  end

  # Parses a date string into year, month, day
  def parse_date(date) do
    date_info = String.split(date, "/")
    {year, _} = Integer.parse(Enum.at(date_info, 0))
    {month, _} = Integer.parse(Enum.at(date_info, 1))
    {day, _} = Integer.parse(Enum.at(date_info, 2))
    {year, month, day}
  end

  # Parses a time string into hour, minute, second
  def parse_time(time, suffix) do
    time_info = String.split(time, ":")
    {hour, _} = Integer.parse(Enum.at(time_info, 0))
    {minute, _} = Integer.parse(Enum.at(time_info, 1))
    second = 0

    # Adding 12 hours if PM
    if suffix == "PM" do
      hour = hour + 12
      {hour, minute, second}
    else
      {hour, minute, second}
    end
  end
end