with dates as (
	select explode(
		sequence(
			to_date('2024-10-21'),
			to_date('2026-10-18'),
			interval 1 day
		)
	) as date_day
)

select
	date_day,
	year(date_day) as year_number,
	quarter(date_day) as quarter_number,
	month(date_day) as month_of_year,
	date_format(date_day, 'MMMM') as month_name,
	weekofyear(date_day) as week_of_year,
	day(date_day) as day_of_month,
	dayofweek(date_day) as day_of_week,
	date_format(date_day, 'EEEE') as day_name,
	dayofyear(date_day) as day_of_year
from dates