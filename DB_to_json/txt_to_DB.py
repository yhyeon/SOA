import getpass
import pymysql

logs = open("F8-63-3F-09-0D-62_2017102801_oa_filtered_ANSI.txt", "r")
con = pymysql.connect(host = "localhost", user = "root", password = getpass.getpass("Password:"), db = "soa", charset = "utf8")
cur = con.cursor()

titles = ['ID', 'IP', 'MAC', 'accessmask', 'eventID', 'Cname', 'Uname', 'date', 'time', 'SID', 'logonID', 'Dname', 'objserver', 'root', 'directory', 'file', 'ext', 'PSname']
print(len(titles))

sql_insert = "INSERT INTO oa_log ("
for i in range(len(titles)):
    if (i != 0):
        sql_insert += ","
    sql_insert += titles[i]
sql_insert += ") values("

i = 0
for line in  logs:
    i += 1
    line = line.strip('\n')
    members = line.split(':::;')
    k = 0
    squery = sql_insert + "'" + str(i) + "'"; k += 1
    for member in members:
        squery += ","
        squery = squery + "'" + member + "'"
        k = k + 1
    squery += ")"
    print(k)
    cur.execute(squery)
logs.close()
print(k)
