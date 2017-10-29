import getpass
import pymysql
import datetime

con = pymysql.connect(host = "localhost", user = "root", password = getpass.getpass("Password:"), db = "reason", charset = "utf8")

cur = con.cursor()

sql_insert = "select * from violation"
cur.execute(sql_insert)
datas = cur.fetchall()

# ----------------------------------------------------------------------------

date_today = datetime.date.today()

json = open(str(date_today)+".json", "w")

titles = ['department', 'name', 'person_number', 'IP', 'MAC', 'media', 'file', 'program', 'receiver', 'violation', 'serious']
i = 0
for data in datas:
    print('{ "index" : {"_id" : "%d" } }' %i)
    json.write('{ "index" : {"_id" : "%d" } }\n' %i)
    contents = "{"
    for j in range(len(data)):
        if(j != 0):
            contents = contents + ", "
        contents = contents + '"' + titles[j] + '" : '
        if(titles[j] != "serious"):
            contents = contents + '"'
        contents = contents + str(data[j])
        if(titles[j] != "serious"):
            contents = contents + '"'
    contents = contents + "}\n"
    print(contents, end = "")
    json.write(contents)
    i = i + 1
#json.write('{ "department" : %s, "name" : %s, "person_number : %s, "IP" : %s, "MAC" : %s, "media", "file" : %s, "program" : %s, "receiver" : %s, "violation" : %s, "serious" : %s }' )

json.close()