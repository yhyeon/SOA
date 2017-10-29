import datetime

logs = open("F8-63-3F-09-0D-62_2017102801_oa_filtered_ANSI.txt", "r")
json = open(str(datetime.date.today())+".json", "w")

titles = ['ID', 'IP', 'MAC', 'accessmask', 'eventID', 'Cname', 'Uname', 'date', 'time', 'SID', 'logonID', 'Dname', 'objserver', 'root', 'directory', 'file', 'ext', 'PSname']

i = 0
for line in logs:
    json.write('{ "index" : {"_id" : "%d"} }\n' %i)
    line = line.strip('\n')
    values = line.split(":::;")

    contents = '{"ID":%d'%i
    for k in range(len(values)):
        contents = contents + ', "' + titles[k + 1] + '":' + '"' + values[k] + '"'
    contents += '}\n'
    json.write(contents)
    i += 1
logs.close()
json.close()