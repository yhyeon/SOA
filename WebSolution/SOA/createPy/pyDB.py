import pymysql

class DB():
    def __init__(self):
        self.connected = False

    def connect(self):
        self.conn = pymysql.connect(host='cdisc.co.kr', port=3306, user='root', password='236p@ssw0rd', db='soa_log', charset='utf8')

        self.curs = self.conn.cursor()
        self.connected = True

    def close(self):
        self.conn.close()
        self.connected = False

    def execute(self, query):
        if not self.connected:
            self.connect()

        self.curs.execute(query)

        rows = self.curs.fetchall()

        return rows

