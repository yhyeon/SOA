#-*- coding:utf-8 -*-

import csv
import os
import sqlite3 as sql
import datetime
import socket
import getpass
from subprocess import check_output
from xml.etree.ElementTree import fromstring
from urllib.parse import urlparse

def getFiletime(dtms):
	if(dtms == 0):
		return (0)
	else:
		seconds, micros = divmod(dtms, 1000000)
		days, seconds = divmod(seconds, 86400)
		return str(datetime.datetime(1601, 1, 1) + (datetime.timedelta(days, seconds, hours =+ 9)))

def match_url(value):
	for row in (rows):
		if(row[0] == value):
			url = row[1]
			return url

def url_details(value):
	for row in (rows):
		if(row[0] == value):
			temp = row[2]
			return temp

def url_count(value):
	for row in (rows):
		if(row[0] == value):
			temp = row[3]
			return temp

def Last_Visit_time(value):
	for row in (rows):
		if(row[0] == value):
			temp = row[5]
			return str(getFiletime(temp))	

def get_IP():
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	s.connect(("8.8.8.8", 80))
	ip = (s.getsockname()[0])
	s.close()
	return ip

def getMac() :

    cmd = 'wmic.exe nicconfig where "IPEnabled  = True" get MACAddress /format:rawxml'
    xml_text = check_output(cmd)
    xml_root = fromstring(xml_text)

    nics = []
    keyslookup = {
        'MACAddress' : 'mac',
    }

    for nic in xml_root.findall("./RESULTS/CIM/INSTANCE") :
        n = {'mac':'',}

        for prop in nic :
            name = keyslookup[prop.attrib['NAME']]
            if prop.tag == 'PROPERTY':
                if len(prop):
                    for v in prop:
                        n[name] = v.text
        nics.append(n)

    return nics

time = datetime.datetime.now()
curr_time = ("%s%s%s" % (time.year, time.month, time.day)) + '_' + time.strftime("%H%M%S")
computer_N = socket.gethostname()

f = open("C:\\Users\\Public\\Documents\\" + computer_N + '_'+ curr_time + '_ChromeHistory'+'.txt', 'w+', encoding='utf8')

data_path = os.path.expanduser('~') + "\\AppData\\Local\\Google\\Chrome\\User Data\\Default"
files = os.listdir(data_path)
history_db = os.path.join(data_path, 'history')

conn = sql.connect(history_db)

cur = conn.cursor()
cur2 = conn.cursor()

cur.execute("SELECT * FROM urls")
cur2.execute("SELECT url, visit_time FROM visits")

rows = cur.fetchall()
rows2 = cur2.fetchall()

nics = getMac()
for nic in nics :
	for k, v in nic.items() :
	    MAC = v
	    MAC2 = MAC.replace(':', '-')

print('-------------------------------------VISIT_HISTORY-------------------------------------')

for num,row in enumerate(rows2):

	host_name = socket.gethostname()
	IP = str(get_IP())
	user_name =  getpass.getuser()
	url = (match_url(row[0]))
	uri = urlparse(url)[1]
	datails = (str(url_details(row[0])))
	visit_time = (getFiletime(row[1]).replace(" ", ":::;"))
	last_visit_time = (Last_Visit_time(row[0]).replace(" ", ":::;"))
	count = str(url_count(row[0]))

	print('Url_Id : ' + str(row[0]) + '\n' + 'URL: ' + url + '\n' + 'URI: ' + uri + '\n' +'URL_Detail: ' + str(datails) 
		+ '\n'+ 'Visit_Time : ' + visit_time + '\n' + 'Last_Visit_Time : ' + last_visit_time + '\n' + 'URL_Count: ' + count)

	print ('====================================================================================')

	f.write(host_name)
	f.write(':::;')
	f.write(user_name)
	f.write(':::;')
	f.write(IP)
	f.write(':::;')
	f.write(MAC2)
	f.write(':::;')
	f.write(str((visit_time)))
	f.write(':::;')
	f.write(last_visit_time)
	f.write(':::;')
	f.write(str((uri)))
	f.write(':::;')
	f.write(str((url)))
	f.write(':::;')
	f.write(str((datails)))
	f.write(':::;')
	f.write(str((count)))
	f.write('\n')	

conn.close()
f.close()