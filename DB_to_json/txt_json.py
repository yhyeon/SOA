import datetime

name = "logs"
logs = open( name + ".txt", "r")
json = open( name + ".json", "w")

columns = ['ID', 'IP', 'MAC', 'Cname', 'SID', 'date', 'time', 'EventID', 'diskNum', 'diskID', 'characteristics', 'bustype', 'manufacturer', 'model', 'modelversion', 'SerialNum', 'parentID', 'registryID']
evt = ['ID', 'datetime', 'eventID', 'event_type', 'Cname']

i = 0
for line in logs:
    json.write('{ "index" : {"_id" : "%d"} }\n' %i)
    line = line.strip('\n')
    values = line.split("\t")

    contents = '{"ID":%d'%i
    for k in range(len(values)):
        contents = contents + ', "' + evt[k + 1] + '":' + '"' + values[k] + '"'
    contents += '}\n'
    json.write(contents)
    i += 1
logs.close()
json.close()
