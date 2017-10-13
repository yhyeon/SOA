#-*- coding:utf-8 -*-
import re
import pymysql
import os
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.base import MIMEBase
from email import encoders

class Detection:
    def __init__(self):
        self.matchLine = []
        self.dedLine = []
        self.cnames = []
        self.logNums = []
        self.logNum = 0

        self.app_pattern = re.compile("KakaoTalk\.exe$")
        self.extension_pattern = re.compile("\.txt$|\.pdf$|\.doc$|\.docx$|\.ppt$|\.pptx$|\.xls$|\.xlsx$|\.hwp$")

        # Set users for gmail
        self.sender = "" # Set Sender Gmail ID
        self.sender_pw = "" # Set Sender Gmail Password
        self.recipients = []
        self.empNums = []

        # Set subject and text
        self.subject = ""
        self.text = ""

        # Set attachments
        self.file_dir = "C:\\Users\\Seojun\\Desktop\\test"
        self.filenames = [os.path.join(self.file_dir, f) for f in os.listdir(self.file_dir)]

    def setMailData(self, i):
        self.subject = "사유서 작성 안내"
        self.text = "해당 사유로인해 사유서작성이 필요합니다.\n" \
                    "아래의 URL에 접속 후 사번과 로그번호를 입력, 사유서를 작성해주시기 바랍니다.\n" \
                    "사번 : %s\n" \
                    "로그번호 : %s\n" \
                    "localhost:8000/employee_login"% (str(self.empNums[i]), str(self.logNums[i]))


    def dbConnect(self):
        self.conn = pymysql.connect(host='localhost', port=3306, user='root', password='wjdqhqhdks', db='SOA', charset='utf8')
        self.curs = self.conn.cursor()

    def dbClose(self):
        self.conn.close()

    def dbCommit(self):
        self.conn.commit()

    def getLogNum(self):
        sql = "select COUNT(*) from obj_access_log"
        self.curs.execute(sql)
        rows = self.curs.fetchall()
        for row in rows:
            self.logNum = row[0]

    def getEmpInfo(self):
        sql = "select EMPnum, email from hrdb where Cname=%s"

        for cname in self.cnames:
            self.curs.execute(sql, cname)
            for row in self.curs.fetchall():
                self.empNums.append(row[0])
                self.recipients.append(row[1])

    def splitCname(self, matchLine):
        return matchLine.split(':::;')[9]

    def deduplication(self):
        leng = len(self.matchLine)
        for i in range(1, leng):
            if (self.matchLine[i - 1].split(':::;')[1:] == self.matchLine[i].split(':::;')[1:]):
                self.dedLine.append(self.matchLine[i])
                self.cnames.append(self.splitCname(self.matchLine[i]))
                self.logNums.append(self.matchLine[i].split(':::;')[0])

    def search_insertDB(self):
        sql = "insert into obj_access_log (accessmask, eventID, Adate, Atime, Cname, SID, Uname, logonID, domainname, objserver, objname, PSname) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

        f = open('C:\\Users\\Seojun\\Desktop\\HYEON_2017101201_oa.txt', 'r')
        lines = f.readlines()
        for line in lines:
            if (self.app_pattern.search(line.split(':::;')[11]) != None):
                if (self.extension_pattern.search(line.split(':::;')[10]) != None):
                    self.logNum = self.logNum + 1
                    self.matchLine.append(str(self.logNum)+':::;'+line)

                    self.curs.execute(sql, (line.split(':::;')[0], line.split(':::;')[1], line.split(':::;')[2],
                                            line.split(':::;')[3], line.split(':::;')[4], line.split(':::;')[5],
                                            line.split(':::;')[6], line.split(':::;')[7], line.split(':::;')[8],
                                            line.split(':::;')[9], line.split(':::;')[10], line.split(':::;')[11]))

                    #self.getEmpInfo(self.curs, line.split(':::;')[4])
                    #self.insertReasonMember(self.curs)

            else:
                self.logNum = self.logNum + 1
                self.curs.execute(sql, (line.split(':::;')[0], line.split(':::;')[1], line.split(':::;')[2],line.split(':::;')[3],
                                        line.split(':::;')[4], line.split(':::;')[5], line.split(':::;')[6],line.split(':::;')[7],
                                        line.split(':::;')[8], line.split(':::;')[9], line.split(':::;')[10], line.split(':::;')[11]))

        f.close()

    def sendMail(self):
        for i in range(0, len(self.recipients)):
            self.setMailData(i)

            msg = MIMEMultipart()
            msg['From'] = self.sender
            msg['To'] = self.recipients[i]
            # msg['To'] = ", ".join(recipients)
            msg['Subject'] = self.subject

            msg.attach(MIMEText(self.text))

            for file in self.filenames:
                part = MIMEBase('application', 'octet-stream')
                part.set_payload(open(file, 'rb').read())
                encoders.encode_base64(part)
                part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(file))
                # print(os.path.basename(file))
                msg.attach(part)

            mailServer = smtplib.SMTP("smtp.gmail.com", 587)
            mailServer.ehlo()
            mailServer.starttls()
            mailServer.ehlo()
            mailServer.login(self.sender, self.sender_pw)
            mailServer.sendmail(self.sender, self.recipients[i], msg.as_string())
            mailServer.close()

    def insertReasonMember(self):
        sql = "insert into reason_member (e_num, log_num, reason_num) values (%s, %s, %s)"
        for i in range(0, len(self.logNums)):
            self.curs.execute(sql, (int(self.empNums[i]), self.logNums[i], 'obj_access'))

det = Detection()
det.dbConnect()
det.getLogNum()
det.search_insertDB()
det.dbCommit()
det.deduplication()
det.getEmpInfo()
det.insertReasonMember()
det.sendMail()
det.dbCommit()
det.dbClose()