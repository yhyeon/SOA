import pymysql
import getpass
import random

# sql query == insert into [Table Name] (field1, field2) values (value1, value2)
#logonoff - datetime, DiskSN, eventid, Logontype
#Accesslog - datetime, DiskSN, eventid, accessmask
#history  - datetime, DiskSN

def check_act(curs, times, DiskSN, act):
    if(act == "Read" or act == "Write" or act == "Delete"):
        db_accesslog(curs, times, DiskSN, 4663, act+"Data")
    elif(act == "Web"):
        db_history(curs, times, DiskSN)
    elif(act == "Net_login"):
        db_logonoff(curs, times, DiskSN, 4624, "3")


def db_logonoff(curs, datetime, DiskSN, eventid, LogonType):
    sql = "insert into logonoff (datetime, DiskSN, eventid, LogonType) values ('%s', '%s', '%s' ,'%s')"\
        %(datetime, DiskSN, eventid, LogonType)
    curs.execute(sql)
def db_accesslog(curs, datetime, DiskSN, eventid, accessmask):
    sql = "insert into oafile (datetime, DiskSN, eventid, accessmask) values ('%s', '%s', '%s' ,'%s')"\
        %(datetime, DiskSN, eventid, accessmask)
    curs.execute(sql)
def db_history(curs, datetime, DiskSN):
    sql = "insert into hist_chrome (datetime, DiskSN, Vcount) values ('%s', '%s', %d)"\
        %(datetime, DiskSN, random.randrange(1,20))
    curs.execute(sql)

if (__name__ == "__main__"):
    con = pymysql.connect(host="cdisc.co.kr", user="root", passwd=getpass.getpass(), db="testlog", charset="utf8mb4")
    curs = con.cursor()
    # Function
    con.commit()