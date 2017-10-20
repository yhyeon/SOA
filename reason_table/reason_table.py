import pandas
import pymysql
import getpass
import matplotlib.pylab as plt
from pylab import figure, axes, pie, title, savefig

con = pymysql.connect(host = 'localhost', user = 'root', password = getpass.getpass("Password: "), db = 'reason', charset = 'utf8')
cur = con.cursor()

sql_insert = "select * from violation"
#(department, name, person_number, IP, MAC, media, file, program, receiver, violation, serious) values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')"


cur.execute(sql_insert)
#%(DF.department[i], DF.name[i], DF.person_number[i], DF.IP[i], DF.MAC[i], DF.media[i], DF.file[i], DF.program[i], DF.receiver[i], DF.violation[i], DF.serious[i]))

titles = ['department', 'name', 'person_number', 'IP', 'MAC', 'media', 'file', 'program', 'receiver', 'violation', 'serious']
data = cur.fetchall()

DF = pandas.DataFrame(list(data), None, titles)
print(DF)

con.close()

PT = pandas.pivot_table(DF, index = "department", columns = ["media"], values = "serious", aggfunc = "count")
print(PT)
PT.plot(kind = 'Bar')
plt.ylabel("Count")

fig = plt.gcf()
fig.savefig("count.png")
plt.show()
