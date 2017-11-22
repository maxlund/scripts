import requests
import bs4 as bs

payload = {
    "-Maxrecords": "2500",
    "kp_programkod": "",
    "kp_institution": "",
    "kp_termin_ber": "",
    "kp_period_ber": "",
    "kp_schemablock": "",
    "kp_huvudomrade_sv": "",
    "kp_utb_niva": "G2",
    "kp_kurskod": "",
    "kp_kursnamn_sv": "",
    "kp_kursinnehall_sv": "",
    "-Search": "S%C3%B6k",
}

institutions = {
    'CTE',
    'EKI',
    'ESI',
    'IBK',
    'IDA',
    'IEI',
    'IFM',
    'IHM',
    'IKE',
    'IKK',
    'IKP',
    'IMH',
    'IMK',
    'IMT',
    'IMV',
    'IPE',
    'ISAK',
    'ISK',
    'ISV',
    'ISY',
    'ITN',
    'ITUF',
    'MAI',
    'TEMA',
    'TFK'
}

levels = {"G1", "G2", "A"}

def get_course_codes(level):

#    payload["kp_institution"] = institution
    payload["kp_utb_niva"] = level

    res = requests.post(url="http://kdb-5.liu.se/liu/lith/studiehandboken/search_17/search_response_sv.lasso", data=payload)
    soup = bs.BeautifulSoup(res.text, "lxml")

    table = soup.find("table")
    table_rows = table.find_all("tr")

    rows = []
    course_codes = []
    for tr in table_rows:
        td = tr.find_all("td")
        rows.append([i.text for i in td])
        row = [i.text for i in td]
        if len(row) == 4 and row[1] != '\xa0':
            course_codes.append(row[1])

    print("** Gathered {} course codes **".format(len(course_codes)))

    return course_codes


# all_course_codes = {}
# for institution in institutions:
#     for level in levels:
#         courses = get_course_codes(institution, level)
#         if len(courses) != 0:
#             all_course_codes[institution] = {level: courses}

# total = 0
# for inst, levs in all_course_codes.items():
#     print("***** INSTITUTION: {}".format(inst))
#     for lev, courses in levs.items():
#         print("***** LEVEL: {}\n{}\n\n".format(lev, courses))
#         total += len(courses)

all_ccs = []
total = 0
for lev in levels:
    courses = get_course_codes(lev)
    all_ccs.append(courses)
    total += len(courses)


print("DONE! Gathered {} course codes".format(total))