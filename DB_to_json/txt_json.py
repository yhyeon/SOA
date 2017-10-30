import datetime

name = "SJ_partition"
logs = open( name + ".txt", "r")
json = open( name + ".json", "w")

columns = ['ID', 'IP', 'MAC', 'Cname', 'SID', 'date', 'time', 'EventID', 'diskNum', 'diskID', 'characteristics', 'bustype', 'manufacturer', 'model', 'modelversion', 'SerialNum', 'parentID', 'registryID']

i = 1390
for line in logs:
    json.write('{ "index" : {"_id" : "%d"} }\n' %i)
    line = line.strip('\n')
    values = line.split(":::;")

    contents = '{"ID":%d'%i
    for k in range(len(values)):
        contents = contents + ', "' + columns[k + 1] + '":' + '"' + values[k] + '"'
    contents += '}\n'
    json.write(contents)
    i += 1
logs.close()
json.close()
