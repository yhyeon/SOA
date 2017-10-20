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
#print(DF)

con.close()

PT = pandas.pivot_table(DF, index = "department", columns = ["media"], values = "serious", aggfunc = "count")
print(PT)


PT.plot(kind = 'Bar')
plt.ylabel("Count")

fig = plt.gcf()
fig.savefig("count.png")
plt.show()
# -------------------------------------------------------------------------------------------------
medias = list(set(DF["media"]))
PT_media = DF.pivot_table(columns = "media", values = "serious", aggfunc = "count")
PT_serious = pandas.pivot_table(DF, columns = "serious", values = "media", aggfunc = "count")
print(PT_media)
print(PT_serious)
# -------------------------------------------------------------------------------------------------
PT = DF.pivot_table(index = "department", values = "serious", aggfunc = "sum")
print(PT)
PT = PT.sort_values("serious")
print(PT["index"])
"""
medias = list(set(DF["media"]))
print(medias)
name_top = {}
for i in range(len(medias)):
    media_top[medias[i]] = []
    PT = DF.pivot_table(index = "media", values = "")
    only = 0
    for TOP in PT[names[i]]:
        name_top[names[i]].append(TOP)
        if(only >= 5):
            break
print(name_top)
"""