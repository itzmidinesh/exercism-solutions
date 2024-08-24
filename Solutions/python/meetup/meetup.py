from datetime import date, timedelta
import calendar


# subclassing the built-in ValueError to create MeetupDayException
class MeetupDayException(ValueError):
    """Exception raised when the Meetup weekday and count do not result in a valid date.

    message: explanation of the error.

    """

    def __init__(self, message="That day does not exist."):
        self.message = message
        super().__init__(self.message)


def meetup(year, month, week, day_of_week):
    days_of_week = {
        "Monday": 0,
        "Tuesday": 1,
        "Wednesday": 2,
        "Thursday": 3,
        "Friday": 4,
        "Saturday": 5,
        "Sunday": 6,
    }

    if week == "teenth":
        for day in range(13, 20):
            if date(year, month, day).weekday() == days_of_week[day_of_week]:
                return date(year, month, day)
    elif week in ["first", "second", "third", "fourth", "fifth", "last"]:
        _, days_in_month = calendar.monthrange(year, month)

        matched_days = [
            day
            for day in range(1, days_in_month + 1)
            if date(year, month, day).weekday() == days_of_week[day_of_week]
        ]

        if week == "first":
            return date(year, month, matched_days[0])
        elif week == "second":
            return date(year, month, matched_days[1])
        elif week == "third":
            return date(year, month, matched_days[2])
        elif week == "fourth":
            return date(year, month, matched_days[3])
        elif week == "fifth":
            if len(matched_days) < 5:
                raise MeetupDayException()
            return date(year, month, matched_days[4])
        elif week == "last":
            return date(year, month, matched_days[-1])

    raise MeetupDayException("Invalid week or day combination.")
