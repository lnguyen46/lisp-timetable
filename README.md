# Timetable app written in Common Lisp

My first Common Lisp app.

It schedules subjects for 24 classes in my fictional Vietnamese secondary school.

This project is a throw-away prototype!

## Web libraries
- [Hunchentoot](http://weitz.de/hunchentoot/) for web server
- [Parenscript](https://common-lisp.net/project/parenscript/) for Javascript stuff
- [cl-who](http://weitz.de/cl-who/) for rendering HTML pages


## Features
When you load the server for the first time, it automatically renders subjects for 24 classes based on these constraints:
- Every class has 4 Math periods/week, 4 Literature/week, 2 Physical Education/week.
- No subject appears 3 or more times a day
- Subjects that have 2-3 periods per week appear exactly once a day
- No day has 2 Math periods *and* 2 Literature periods.
- Every class has one day having consecutive Math periods and one day having consecutive Literature periods.

## Usage
1. Clone this repo where Quicklisp can find it:
`git@github.com:lnguyen46/lisp-timetable.git ~/common-lisp/`

2. Jump to REPL and type:
`ql:quickload :time-table`

3. Still in REPL, start local server
`(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4242))`

4. Go to: http://127.0.0.1:4242/ to see the result.

## Screenshot
<img src="https://user-images.githubusercontent.com/22726858/42568351-05461292-8537-11e8-8e5f-26258d8e7b4d.png">

