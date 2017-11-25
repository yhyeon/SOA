mapping = open("mapping.txt", "w")

file_scan = [('Adate', 'date'), ('Atime', 'date'), ('Cdate', 'date'), ('Ctime', 'date'), ('Fname', 'string'), ('ID', 'integer'), ('IP', 'string'), ('MAC', 'string'), ('Mdate', 'date'), ('UDnme', 'string'), ('Uname', 'string')]
driver = [('ID', 'integer'), ('IP', 'text'), ('MAC', 'text'), ('Cname', 'text'), ('SID', 'text'), ('date', 'date'), ('time', 'date'), ('EventID', 'text'), ('lifetime', 'text'), ('HostGUID', 'text'), ('device', 'text'), ('statuinfo', 'text')]

mapping.write("{\n")
mapping.write('\t"file_scan": {\n')
mapping.write('\t\t"properties": {')
for i in range(len(driver)):
    if(i != 0):
        mapping.write(', ')
    mapping.write('\n\t\t\t"%s": {"type": "%s" }' %(driver[i][0], driver[i][1]))
mapping.write("\n\t\t}\n")
mapping.write('\t}\n')
mapping.write('}')

mapping.close()
