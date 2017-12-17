import datetime
from ToDB import *

def check_time(times):
    if(times.time() > datetime.datetime.strptime("17:50", "%H:%M").time()):     #Closing hour
        log_off(times)
        return (-1)
    elif(datetime.datetime.strptime("11:50", "%H:%M").time() < times.time()     #Lunch time
             < datetime.datetime.strptime("12:35", "%H:%M").time()):
        log_off(times)
        times += datetime.timedelta(minutes = random.randrange(30, 60),
                milliseconds = random.randrange(1, 60000), microseconds = random.randrange(1, 1000))
        log_in(times)
    elif(times.minute < 10 or times.minute > 40):                               #Break time
        select = random.randrange(1,100)
        if(1 <= select <= 40):
            log_off(times)
            times += datetime.timedelta(minutes=random.randrange(3, 15),
                    milliseconds=random.randrange(1, 60000), microseconds=random.randrange(1, 1000))
            log_in(times)
    return (times)

def event(times):
    select = random.randrange(1, 100)
#확률마다 이벤트 발생
    if (1 <= select <= 30):
        print("Document Working")
        times = work_unit(times, document_acts)
    elif (31 <= select <= 50):
        print("Web Searching")
        times = work_unit(times, web_acts)
    elif (51 <= select <= 65):
        print("Web Searching + Document")
        times = work_unit(times, web_document_acts)
    elif (66 <= select <= 80):
        print("Document + Web Searching")
        times = work_unit(times, document_web_acts)
    elif (81 <= select <= 91):
        print("Find Information")
        times = work_unit(times, find_acts)
    elif (91 <=select <= 95):
        print("Delete")
        times = work_unit(times, delete_acts)
    elif (95 <= select <= 100):
        print("Share Access")
        times = work_unit(times, share_acts)
    return times

#이벤트 함수
def work_unit(times, acts):         # 인자로 acts를 받음
    for i in range(len(acts)):
        print(times, [acts[i]])
        check_act(curs, times, DiskSN, acts[i])
        log_file.write(acts[i]+',')
        times += datetime.timedelta(minutes = random.randrange(1, 14),
                milliseconds = random.randrange(1, 60000), microseconds = random.randrange(1, 1000))      #랜덤하게 시간 간격 결정
    return(times)

def log_in(times):
    select = random.randrange(1,100)
    if(1 <=select <= 90):
        print(times, ["Log On"])
        db_logonoff(curs, times, DiskSN, 4624, "7")
        log_file.write("Log On,")
    elif(91 <= select <= 100):
        print(times, ["Log On Failed"])
        db_logonoff(curs, times, DiskSN, 4625, "7")
        log_file.write("Log On Failed,")
        times += datetime.timedelta(milliseconds = random.randrange(1, 15000))
        log_in(times)
    times += datetime.timedelta(minutes = random.randrange(0, 1),
                milliseconds = random.randrange(1, 60000), microseconds = random.randrange(1, 1000))
    return(times)

def log_off(times):
    print(times, ["Log off"])
    db_logonoff(curs, times, DiskSN, 4634, "7")
    log_file.write("Log Off,")

if __name__ == "__main__":
    con = pymysql.connect(host="cdisc.co.kr", user="root", passwd=getpass.getpass(), db="testlog", charset="utf8mb4")
    curs = con.cursor()

    DiskSN = "Googy"
    document_acts = ["Read", "Write", "Write"]
    web_acts = ["Web", "Web"]
    web_document_acts = ["Web", "Write"]
    document_web_acts = ["Write", "Web"]
    find_acts = [ "Read", "Read"]
    delete_acts = ["Delete"]
    share_acts = ["Net_login"]

    date = input("Set Start Date (YYYY-mm-dd):")
    date = datetime.datetime.strptime(date, "%Y-%m-%d")
    period = int(input("Set_period:"))

    log_file = open(str(date.date())+".txt", "w")

    for i in range(period):
        time = datetime.timedelta(hours = 8, minutes = 40)      # Need to make virtual time

        login_time = date + time + datetime.timedelta(minutes = random.randrange(30),
                    milliseconds = random.randrange(1, 60000), microseconds = random.randrange(1, 1000))
        event_time = log_in(login_time)

        while(True):
            event_time = check_time(event_time)
            if(event_time == -1):
                print("Bye")
                break;
            else:
                event_time = event(event_time)
        date = date + datetime.timedelta(days=1)
    con.commit()
    log_file.close()