#!/usr/bin/env python3

import requests
import bs4 as bs

course_code = "TDDE01"
res = requests.get("http://www4.student.liu.se/tentaresult/?kurskod=" + course_code + "&search=S%F6k")

try:
    res.raise_for_status()
except Exception as e:
    print(course_code + " raised an exception %s" % (e))

course_file = open("courses/" + course_code, "wb")
for chunk in res.iter_content(100000):
    course_file.write(chunk)

some_course = open("courses/"+course_code, "rb")
soup = bs.BeautifulSoup(some_course, "lxml")

tables = soup.find_all("table")[4:5][0].text.split(":")

exams = []
[exams.append(res.split("\n")) for res in tables[1:] if "tentamen" in res]

all_dates = {} # all exam results

for ex in exams:
    results = [res.split(" ") for res in ex[ex.index("BetygAntal")+1:len(ex)-1]]
    date = {res[0]: res[1] for res in results}
    all_dates[ex[0][-10:]] = date

for ex in exams:
    print(ex)

for date, results in all_dates.items():
    print(date)
    for grade, score in results.items():
        print(grade, score)


