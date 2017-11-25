import pandas
import pymysql
import getpass
import matplotlib.pylab as plt
from matplotlib import font_manager, rc
from pylab import figure, axes, pie, title, savefig
import operator

con = pymysql.connect(host = 'cdisc.co.kr', user = 'root', password = getpass.getpass("Password: "), db = 'soa_log', charset = 'utf8')
cur = con.cursor()

sql_insert = "select * from uactiv_report_saves"
cur.execute(sql_insert)

#titles = ['center_team', 'name', 'person_number', 'IP', 'MAC', 'reasontype', 'file', 'program', 'receiver', 'violation', 'severity']
titles = ['ID', 'Wdate', 'EMPnum', 'EMPname', 'center_team', 'position', 'reasontype', 'lognum', 'logtable', 'IP', 'MAC', 'outflow_File', 'url_Link', 'model', 'owner', 'source', 'application', 'receiver', 'rf_outflow_File', 'rf_outflow_File_detail', 'upfilename', 'violation', 'severity']
data = cur.fetchall()
DF = pandas.DataFrame(list(data), index = None, columns = titles)
con.close()
print(DF)
# -------------------------------------------------------------------------------------------------     Pivot Table / Graph
font_location = "C:\Windows\Fonts\malgunbd.ttf"
font_name = font_manager.FontProperties(fname = font_location).get_name()
rc('font', family = font_name)

PT = pandas.pivot_table(DF, index = "center_team", columns = "reasontype", values = "violation", aggfunc = "count")
print(PT)
PT.plot(kind = 'Bar')
plt.ylabel("Count")
plt.xticks(rotation = 0)

fig = plt.gcf()
fig.savefig("count.png")
#plt.show()
print("end")
"""
# -------------------------------------------------------------------------------------------------
reasontypes = list(set(DF["reasontype"]))
severityes = list(set(DF["severity"]))
PT_reasontype = DF.pivot_table(columns = "reasontype", values = "severity", aggfunc = "count")
PT_severity = pandas.pivot_table(DF, columns = "severity", values = "reasontype", aggfunc = "count")
#print(PT_reasontype)
for reasontype in reasontypes:
    print("reasontype(%s) - " %reasontype, end = "")
    print(PT_reasontype[reasontype][0])
print("")
for severity in severityes:
    print("severity(%s) - " %severity, end = "")
    print(PT_severity[severity][0])

# -------------------------------------------------------------------------------------------------     top5
parts = list(set(DF["center_team"]))
part_top = {}
PT = DF.pivot_table(columns = "center_team", values = "severity", aggfunc = "sum")
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
PT = DF.pivot_table(columns = "name", values = "severity", aggfunc = "count")

name_value = {}
values = []
for name in PT:
    name_value[name] = PT[name][0]
print(name_value)

name_value_sort = sorted(name_value.items(), key = operator.itemgetter(1), reverse = True)
filter_name = name_value_sort[0][0]
print("주요 위반자: ", filter_name)
DF_by_name = DF.sort_values("name")

name_range = []
i = 0
for name in DF_by_name["name"]:
    if (name == filter_name):
        name_range.append(i)
    i = i + 1
DF_filtered = DF_by_name[min(name_range):max(name_range) + 1]
for file in DF_filtered["file"]:
    print("반출파일:", file)
"""
