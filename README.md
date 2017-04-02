# Timetable app written in Common Lisp

My first Common Lisp app.

It schedules subjects for 24 classes in my fictional Vietnamese secondary school.

This project is a throw-away prototype!

## Web libraries
- Hunchentoot for web server
- Parenscript for Javascript stuff
- cl-who for rendering HTML pages


## Features
When you load the server for the first time, it automatically renders subjects for 24 classes based on these constraints:
- Every class has 4 Math periods/week, 4 Literature/week, 2 Physical Education/week.
- No subject appears 3 or more times a day
- Subjects that have 2-3 periods per week appear exactly once a day
- No day has 2 Math periods *and* 2 Literature periods.
- Every class has one day having consecutive Math periods and one day having consecutive Literature periods.
