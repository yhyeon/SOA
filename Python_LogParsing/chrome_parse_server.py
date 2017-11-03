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
import fnmatch

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

def State(state):
	if(state == 0):
		msg = (('Download in progress'))
		return msg
	elif(state == 1):
		msg = (('Download completed'))
		return msg
	elif(state == 2):
		msg = (('Download cancelled'))
		return msg
	elif(state == 3):
		msg = (('Download interrupted'))
		return msg
	elif(state == 4):
		msg = (('Maximum download state reached'))
		return msg

def Danger_Type(danger):
	if(danger == 0):
		msg = str(('Not dangerous'))
		return msg
	elif(danger == 1):
		msg = str(('File dangerous to system (*.pdf)'))
		return msg
	elif(danger == 2):
		msg = str(('File URLs is malicious'))
		return msg
	elif(danger == 3):
		msg = str(('File content is malicious'))
		return msg
	elif(danger == 4):
		msg = str(('Potentially dangerous (*.exe)'))
		return msg
	elif(danger == 5):
		msg = str(('Unknown/Uncommon content'))
		return msg
	elif(danger == 6):
		msg = str(('Dangerous, used ignore it'))
		return msg
	elif(danger == 7):
		msg = str(('File from dangerous host'))
		return msg
	elif(danger == 8):
		msg = str(('Dangerous to browser'))
		return msg
	elif(danger == 9):
		msg = str(('Maximum (internal)'))
		return msg

def Interrupt_Reason(reason):
	if(reason == 0):
		msg = str(('Not interrupted'))
		return msg
	elif(reason == 1):
		msg = str(('Generic file operation failure'))
		return msg
	elif(reason == 2):
		msg = str(('Access to file denied'))
		return msg
	elif(reason == 3):
		msg = str(('Not enough free space'))
		return msg
	elif(reason == 5):
		msg = str(('File name is too long'))
		return msg
	elif(reason == 6):
		msg = str(('File is too large for file system'))
		return msg
	elif(reason == 7):
		msg = str(('Virus infected file'))
		return msg
	elif(reason == 10):
		msg = str(('File in use (transient error)'))
		return msg
	elif(reason == 11):
		msg = str(('File blocked by local policy'))
		return msg
	elif(reason == 12):
		msg = str(('File security check failed'))
		return msg
	elif(reason == 13):
		msg = str(('Download revive error'))
		return msg
	elif(reason == 20):
		msg = str(('Generic network failure'))
		return msg
	elif(reason == 21):
		msg = str(('Network operation timed out'))
		return msg
	elif(reason == 22):
		msg = str(('Connection lost'))
		return msg
	elif(reason == 23):
		msg = str(('Server has gone offline'))
		return msg
	elif(reason == 24):
		msg = str(('Network request invalid'))
		return msg
	elif(reason == 30):
		msg = str((' Server operation failed'))
		return msg
	elif(reason == 31):
		msg = str((' Unsupported range request'))
		return msg
	elif(reason == 32):
		msg = str(('Request does not meet precondition'))
		return msg
	elif(reason == 33):
		msg = str(('Server does not have requested data'))
		return msg
	elif(reason == 40):
		msg = str(('User cancelled download'))
		return msg
	elif(reason == 41):
		msg = str(('User shut down the browser'))
		return msg
	elif(reason == 50):
		msg = str(('Browser crashed (internal only)'))
		return msg


data_path = os.path.expanduser('~') + "\\Desktop\\history_test"
# data_path = "C:\\soa\\upload"

for path, dir, files in os.walk(data_path):
	for filename in files:
		if fnmatch.fnmatch(filename, '*_ChromeHistory'):
			tmp = filename.split('_')
			print(tmp)
			Cname = tmp[0]
			Uname = tmp[1]
			IP = tmp[2]
			MAC = tmp[3]
			if(tmp[-1] == 'ChromeHistory'):
				f = open("C:\\Users\\Public\\Documents\\" + tmp[3] + '_'+ tmp[4] + '_ChromeHistory'+'.txt', 'w+', encoding='utf8')
				f2 = open("C:\\Users\\Public\\Documents\\" + tmp[3] + '_'+ tmp[4] + '_ChromeDownloads'+'.txt', 'w+', encoding='utf8')

				history_db = os.path.join(data_path, filename)
				conn = sql.connect(history_db)
				print (filename)
				cur = conn.cursor()
				cur2 = conn.cursor()
				cur3 = conn.cursor()

				cur.execute("SELECT * FROM urls")
				cur2.execute("SELECT url, visit_time FROM visits")
				cur3.execute("SELECT * FROM downloads")

				rows = cur.fetchall()
				rows2 = cur2.fetchall()
				rows3 = cur3.fetchall()

				nics = getMac()
				for nic in nics :
					for k, v in nic.items() :
					    MAC = v
					    MAC2 = MAC.replace(':', '-')

				for num,row in enumerate(rows2):
					url1 = (match_url(row[0]))
					uri1 = urlparse(url1)[1]
					datails = (str(url_details(row[0])))
					visit_time = (getFiletime(row[1]).replace(" ", "T")) + '+09:00'
					last_visit_time = (Last_Visit_time(row[0]).replace(" ", "T")) + '+09:00'
					count = str(url_count(row[0]))

					f.write(Cname)
					f.write(':::;')
					f.write(Uname)
					f.write(':::;')
					f.write(IP)
					f.write(':::;')
					f.write(MAC)
					f.write(':::;')
					f.write(str((visit_time)))
					f.write(':::;')
					f.write(last_visit_time)
					f.write(':::;')
					f.write(str((uri1)))
					f.write(':::;')
					f.write(str((url1)))
					f.write(':::;')
					f.write(str((datails)))
					f.write(':::;')
					f.write(str((count)))
					f.write(':::;')
					f.write('\n')	

				for num3 , row3 in enumerate(rows3):
					uri = urlparse(row3[15])[1]
					temp = (row3[2].split("\\"))
					file_name = temp[-1]
					# file_name.split(".")
					extent = file_name.split(".")[-1]

					f2.write(Cname + ':::;' + Uname + ':::;' + str(IP) + ':::;' + (MAC) + ':::;' + (row3[1]) + ':::;' + (row3[2])
					 + ':::;' + (row3[3]) + ':::;' + (getFiletime((row3[4])).replace(" ", "T"))+ '+09:00' + ':::;' + str(row3[5]) + ':::;' + str(row3[6]) + ':::;' + State((row3[7])) + ':::;' + Danger_Type(row3[8])
					 + ':::;' + str(Interrupt_Reason((row3[9]))) + ':::;' + (row3[15]) + ':::;' + (uri) + ':::;' + str(row3[24]) + ':::;' + (file_name) + ':::;' + '.'+(extent) + ':::;')
					f2.write('\n')

			conn.close()
			f.close()
			f2.close()


# f = open("C:\\Users\\Public\\Documents\\" + computer_N + '_'+ curr_time + '_ChromeHistory'+'.txt', 'w+', encoding='utf8')

# data_path = os.path.expanduser('~') + "\\AppData\\Local\\Google\\Chrome\\User Data\\Default"
# files = os.listdir(data_path)
# history_db = os.path.join(data_path, 'history')

# conn = sql.connect(history_db)

# cur = conn.cursor()
# cur2 = conn.cursor()

# cur.execute("SELECT * FROM urls")
# cur2.execute("SELECT url, visit_time FROM visits")

# rows = cur.fetchall()
# rows2 = cur2.fetchall()

# nics = getMac()
# for nic in nics :
# 	for k, v in nic.items() :
# 	    MAC = v
# 	    MAC2 = MAC.replace(':', '-')

# print('-------------------------------------VISIT_HISTORY-------------------------------------')

# for num,row in enumerate(rows2):

# 	host_name = socket.gethostname()
# 	IP = str(get_IP())
# 	user_name =  getpass.getuser()
# 	url = (match_url(row[0]))
# 	uri = urlparse(url)[1]
# 	datails = (str(url_details(row[0])))
# 	visit_time = (getFiletime(row[1]).replace(" ", ":::;"))
# 	last_visit_time = (Last_Visit_time(row[0]).replace(" ", ":::;"))
# 	count = str(url_count(row[0]))

# 	print('Url_Id : ' + str(row[0]) + '\n' + 'URL: ' + url + '\n' + 'URI: ' + uri + '\n' +'URL_Detail: ' + str(datails) 
# 		+ '\n'+ 'Visit_Time : ' + visit_time + '\n' + 'Last_Visit_Time : ' + last_visit_time + '\n' + 'URL_Count: ' + count)

# 	print ('====================================================================================')

# 	f.write(host_name)
# 	f.write(':::;')
# 	f.write(user_name)
# 	f.write(':::;')
# 	f.write(IP)
# 	f.write(':::;')
# 	f.write(MAC2)
# 	f.write(':::;')
# 	f.write(str((visit_time)))
# 	f.write(':::;')
# 	f.write(last_visit_time)
# 	f.write(':::;')
# 	f.write(str((uri)))
# 	f.write(':::;')
# 	f.write(str((url)))
# 	f.write(':::;')
# 	f.write(str((datails)))
# 	f.write(':::;')
# 	f.write(str((count)))
# 	f.write('\n')	

# conn.close()
# f.close()