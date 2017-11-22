import requests, json, pandas
import bs4 as bs

payload = {
    "-Maxrecords": "600",
    "-Operator": "equals",
    "kp_programkod": "",
    "-Operator": "equals",
    "kp_institution": "IDA",
    "-Operator": "equals",
    "kp_termin_ber": "",
    "-Operator": "bw",
    "kp_period_ber": "",
    "-Operator": "eq",
    "kp_schemablock": "",
    "-Operator": "cn",
    "kp_huvudomrade_sv": "",
    "-Operator": "eq",
    "kp_utb_niva": "G1",
    "-Op": "cn",
    "kp_kurskod": "",
    "-Op": "cn",
    "kp_kursnamn_sv": "",
    "-Op": "cn",
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

def get_course_codes(institution, level):

    payload["kp_institution"] = institution
    payload["kp_utb_niva"] = level

    res = requests.post(url="http://kdb-5.liu.se/liu/lith/studiehandboken/search_17/search_response_sv.lasso", data=payload)

    soup = bs.BeautifulSoup(res.text, "lxml")

    table = soup.find("table")
    table_rows = table.find_all("tr")

    rows = []
    for tr in table_rows:
        td = tr.find_all("td")
        rows.append([i.text for i in td])

    courses = []
    [courses.append(row) for row in rows if len(row) == 4]

    course_codes = []
    [course_codes.append(code[1]) for code in courses if code[1] != '\xa0']

    print(course_codes)

    return course_codes

# example
IDA_advanced_courses = get_course_codes("IDA", "A")