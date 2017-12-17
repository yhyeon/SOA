#-*- coding:utf-8 -*-
import re
import pymysql
import os
import smtplib
from datetime import datetime
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.base import MIMEBase
from email import encoders

class Detection:
    def __init__(self):
        self.matchRow = []
        self.logNum = 0
        self.empName = ""
        self.empNum = ""
        self.position = ""
        self.datetime = ""
        self.cname = ""
        self.uname = ""
        self.psname = ""
        self.file = ""

        self.currentDate = datetime.today()

        self.app_pattern = re.compile("KakaoTalk\.exe$")
        self.extension_pattern = re.compile("\.txt$|\.pdf$|\.doc$|\.docx$|\.ppt$|\.pptx$|\.xls$|\.xlsx$|\.hwp$")

        # Set users for gmail
        self.sender = "" # Set Sender Gmail ID
        self.sender_pw = "" # Set Sender Gmail Password
        self.recipient = ""

        # Set subject and text
        self.subject = ""
        self.text = ""

        # Set attachments
        #self.file_dir = "C:\\Users\\Seojun\\Desktop\\test"
        #self.filenames = [os.path.join(self.file_dir, f) for f in os.listdir(self.file_dir)]

    def setMailData(self):
        self.subject = "사유서 작성 안내"
        self.text = "안녕하십니까 보안팀입니다.\n\n" \
                    "%s %s님, 평소 업무 협조에 감사드립니다.\n\n" \
                    "%s/%s에 다음과 같은 특이 사항이 회사 보안 시스템에 탐지되어 연락드립니다. 아래 '사유서 작성 링크'에 접속하시어 관련 사항 확인 부탁드립니다.\n\n" \
                    "- 사유서 작성 링크 : http://cdisc.co.kr:8000/employee_login/\n\n" \
                    "- 사유서 작성 방법 : http://cdisc.co.kr:8000/howto/\n\n" \
                    "- 사유서 제출 기한 : %s\n\n" \
                    "- 로그 번호 : %s\n\n" \
                    "※ 특정 사유로 인하여 위 기한까지 제출이 어려운 경우, 간단한 사유와 함께 언제까지 제출하실 수 있는지 회신주시기 바랍니다.\n\n" \
                    "※ 회사 보안 규정 : http://cdisc.co.kr:8000/security_reg/\n" \
                    "기타 문의 사항은 보안팀으로 연락주시기 바랍니다.\n\n" \
                    "협조해주셔서 감사합니다.\n\n" \
                    "보안팀 드림."% (self.empName, self.position, self.datetime.split('T')[0].split('-')[1], self.datetime.split('T')[0].split('-')[2], (str(self.currentDate.year)+"."+str(self.currentDate.month)+"."+str(self.currentDate.day+3)+". 23:59:59"), str(self.logNum))

    def dbConnect(self):
        self.conn = pymysql.connect(host='cdisc.co.kr', port=3306, user='root', password='236p@ssw0rd', db='soa_log', charset='utf8')
        self.curs = self.conn.cursor()

    def dbClose(self):
        self.conn.close()

    def dbCommit(self):
        self.conn.commit()

    def getEmpInfo(self, MAC):
        sql = "select EMPnum, EMPname, position, email from hrdb where MAC=%s"

        self.curs.execute(sql, MAC)
        rows = self.curs.fetchall()
        for row in rows:
            print(row)
            self.empNum = row[0]
            self.empName = row[1]
            self.position = row[2]
            self.recipient = row[3]

    def search_insertDB(self):
        sql = "select * from oafile"

        self.curs.execute(sql)
        rows = self.curs.fetchall()

        for row in rows:
            if(self.app_pattern.search(row[17]) != None):
                if(self.extension_pattern.search(row[16]) != None):
                    self.matchRow.append(row)
                    print(row)

                    self.getEmpInfo(row[3])
                    self.logNum = row[0]
                    self.cname = row[6]
                    self.uname = row[7]
                    self.datetime = row[8]
                    self.file = row[15]
                    self.psname = row[17]
                    self.insertReasonMember()
                    self.sendMail()

    def sendMail(self):
        self.setMailData()

        msg = MIMEMultipart()
        msg['From'] = self.sender
        msg['To'] = self.recipient
        # msg['To'] = ", ".join(recipients)
        msg['Subject'] = self.subject

        msg.attach(MIMEText(self.text))

        '''
        if self.filenames:
            for file in self.filenames:
                part = MIMEBase('application', 'octet-stream')
                part.set_payload(open(file, 'rb').read())
                encoders.encode_base64(part)
                part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(file))
                # print(os.path.basename(file))
                msg.attach(part)
        '''

        mailServer = smtplib.SMTP("smtp.gmail.com", 587)
        mailServer.ehlo()
        mailServer.starttls()
        mailServer.ehlo()
        mailServer.login(self.sender, self.sender_pw)
        mailServer.sendmail(self.sender, self.recipient, msg.as_string())
        mailServer.close()

    def insertReasonMember(self):
        sql = "insert into uactiv_report_send(EMPnum, lognum, reasontype, logtable) values (%s, %s, %s, %s)"

        self.curs.execute(sql, (int(self.empNum), self.logNum, 'APP', 'oafile'))
        self.dbCommit()

det = Detection()
det.dbConnect()
det.search_insertDB()
det.dbClose()