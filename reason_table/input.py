import pandas
import pymysql
import getpass

DF = pandas.read_excel("reason_statement.xlsx")

con = pymysql.connect(host = 'localhost', user = 'root', password = getpass.getpass("Password: "), db = 'reason', charset = 'utf8')
cur = con.cursor()
sql_insert = "insert violation (department, name, person_number, IP, MAC, media, file, program, receiver, violation, serious) values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')"
cur.execute("DELETE FROM violation")
i = 0
for i in range(len(DF)):
    cur.execute(sql_insert %(DF.department[i], DF.name[i], DF.person_number[i], DF.IP[i], DF.MAC[i], DF.media[i], DF.file[i], DF.program[i], DF.receiver[i], DF.violation[i], DF.serious[i]))
con.commit()
con.close()
