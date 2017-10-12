#-*- coding:utf-8 -*-

import csv
import os
import sqlite3 as sql
import datetime
import socket
import getpass
from subprocess import check_output
from urllib.parse import urlparse
from xml.etree.ElementTree import fromstring

def getFiletime(dtms):
	if(dtms == 0):
		return (0)
	else:
		seconds, micros = divmod(dtms, 1000000)
		days, seconds = divmod(seconds, 86400)
		return str(datetime.datetime(1601, 1, 1) + (datetime.timedelta(days, seconds, micros, hours =+ 9)))

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

f1 = open("C:\\Users\\Public\\Documents\\" + computer_N + '_'+ curr_time + '_ChromeDownloads'+'.txt', 'w+', encoding='utf8')

data_path = os.path.expanduser('~') + "\\AppData\\Local\\Google\\Chrome\\User Data\\Default"
files = os.listdir(data_path)
history_db = os.path.join(data_path, 'history')

conn = sql.connect(history_db)

# conn = sql.connect(r"C:\Users\gayou\AppData\Local\Google\Chrome\User Data\Default\History")
cur = conn.cursor()
cur.execute("SELECT * FROM downloads")

nics = getMac()
for nic in nics :
	for k, v in nic.items() :
	    MAC = v
	    MAC2 = MAC.replace(':', '-')

rows = cur.fetchall()
for num,row in enumerate(rows):

	uri = urlparse(row[15])[1]
	temp = (row[2].split("\\"))
	file_name = temp[-1]
	# file_name.split(".")
	extent = file_name.split(".")[-1]


	f1.write(socket.gethostname() + ':::;' + getpass.getuser() + ':::;' + str(get_IP()) + ':::;' + (MAC2) + ':::;' + (row[1]) + ':::;' + (row[2])
	 + ':::;' + (row[3]) + ':::;' + (getFiletime((row[4])).replace(" ", ":::;")) + ':::;' + str(row[5]) + ':::;' + str(row[6]) + ':::;' + State((row[7])) + ':::;' + Danger_Type(row[8])
	 + ':::;' + str(Interrupt_Reason((row[9]))) + ':::;' + (row[15]) + ':::;' + (uri) + ':::;' + str(row[24]) + ':::;' + (file_name) + ':::;' + '.'+(extent))
	f1.write('\n')


# 	Downloads_list = ('Downloads list [' + str(num + 1) + ']')
# 	GUID = ('GUID ' +  ': ' + (row[1]))
# 	Current_Path = ('Current_Path: ' + (row[2]))
# 	Target_Path = ((row[3]))
# 	Start_Download_Time = (getFiletime((row[4])))
# 	Recieved_Bytes = (str(row[5]) + ' Bytes')
# 	Total_Bytes = (str(row[6]) + ' Bytes')
# 	State = (State(row[7]))
# 	Danger_Type = (Danger_Type(row[8]))
# 	Interrupt_Reason = (str(Interrupt_Reason((row[9]))))
# 	URL = (row[15])
# 	Site_lastmodified_Time = (row[23])
# 	File_Type = str(row[24])


f1.close()
conn.close()
