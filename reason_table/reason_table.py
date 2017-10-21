import pandas
import pymysql
import getpass
import matplotlib.pylab as plt
from matplotlib import font_manager, rc
from pylab import figure, axes, pie, title, savefig
import operator

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
# -------------------------------------------------------------------------------------------------     Pivot Table / Graph
font_location = "C:\Windows\Fonts\malgunbd.ttf"
font_name = font_manager.FontProperties(fname = font_location).get_name()
rc('font', family = font_name)

PT = pandas.pivot_table(DF, index = "department", columns = ["media"], values = "serious", aggfunc = "count")
#print(PT)

PT.plot(kind = 'Bar')
plt.ylabel("Count")
plt.xticks(rotation = 45)

fig = plt.gcf()
fig.savefig("count.png")
plt.show()
# -------------------------------------------------------------------------------------------------
medias = list(set(DF["media"]))
seriouses = list(set(DF["serious"]))
PT_media = DF.pivot_table(columns = "media", values = "serious", aggfunc = "count")
PT_serious = pandas.pivot_table(DF, columns = "serious", values = "media", aggfunc = "count")
#print(PT_media)
for media in medias:
    print("media(%s) - " %media, end = "")
    print(PT_media[media][0])
print("")
for serious in seriouses:
    print("serious(%s) - " %serious, end = "")
    print(PT_serious[serious][0])
# -------------------------------------------------------------------------------------------------     top5
parts = list(set(DF["department"]))
part_top = {}
PT = DF.pivot_table(columns = "department", values = "serious", aggfunc = "sum")
#print(PT)
for i in range(len(parts)):
    part_top[parts[i]] = []
    part_top[parts[i]].append(PT[parts[i]][0])

part_top = sorted(part_top.items(), key = operator.itemgetter(1), reverse = True)

top5 = []
for mem in part_top:
    top5.append(mem[0])
print(top5)
# -------------------------------------------------------------------------------------------------