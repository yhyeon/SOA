# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from __future__ import unicode_literals

from django.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=80)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class ClipProc(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    window = models.CharField(max_length=255)
    process = models.CharField(max_length=255)
    starttime = models.CharField(max_length=40)
    datetime = models.CharField(max_length=40)
    curs = models.CharField(max_length=5)

    class Meta:
        managed = False
        db_table = 'clip_proc'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class DownChrome(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    guid = models.CharField(db_column='GUID', max_length=255)  # Field name made lowercase.
    current_path = models.CharField(max_length=255)
    target_path = models.CharField(max_length=255)
    datetime = models.CharField(max_length=40)
    received_bytes = models.CharField(max_length=255)
    total_bytes = models.CharField(max_length=255)
    state = models.CharField(max_length=255)
    danger_type = models.CharField(max_length=255)
    interrupt_reason = models.CharField(max_length=255)
    uri = models.CharField(max_length=255, blank=True, null=True)
    url = models.CharField(max_length=255, blank=True, null=True)
    fname = models.CharField(db_column='Fname', max_length=255)  # Field name made lowercase.
    ext = models.CharField(max_length=10)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'down_chrome'


class DriverWin7(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    sid = models.CharField(db_column='SID', max_length=255)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    eventid = models.IntegerField(db_column='EventID')  # Field name made lowercase.
    lifetime = models.CharField(max_length=255)
    hostguid = models.CharField(db_column='HostGUID', max_length=255)  # Field name made lowercase.
    device = models.CharField(max_length=255)
    statusinfo = models.CharField(max_length=255)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'driver_win7'


class Fscan(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    cdatetime = models.CharField(db_column='Cdatetime', max_length=40)  # Field name made lowercase.
    adatetime = models.CharField(db_column='Adatetime', max_length=40)  # Field name made lowercase.
    mdatetime = models.CharField(db_column='Mdatetime', max_length=40)  # Field name made lowercase.
    size_kb = models.CharField(db_column='size_KB', max_length=255)  # Field name made lowercase.
    rootdir = models.CharField(max_length=255)
    dirname = models.CharField(max_length=255)
    fname = models.CharField(db_column='Fname', max_length=255)  # Field name made lowercase.
    basename = models.CharField(max_length=255)
    ext = models.CharField(max_length=10)
    attrib = models.CharField(max_length=255)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'fscan'


class HistChrome(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    lvdatetime = models.CharField(db_column='LVdatetime', max_length=40)  # Field name made lowercase.
    uri = models.CharField(max_length=255, blank=True, null=True)
    url = models.CharField(max_length=255, blank=True, null=True)
    site_name = models.CharField(max_length=255)
    vcount = models.IntegerField(db_column='Vcount')  # Field name made lowercase.
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'hist_chrome'


class HistIe(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    uri = models.CharField(max_length=255)
    url = models.CharField(max_length=255)
    sname = models.CharField(db_column='Sname', max_length=255)  # Field name made lowercase.
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'hist_ie'


class Hrdb(models.Model):
    empnum = models.IntegerField(db_column='EMPnum', primary_key=True)  # Field name made lowercase.
    empname = models.CharField(db_column='EMPname', max_length=20)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    center = models.CharField(max_length=255)
    teamnum = models.IntegerField(db_column='teamNum')  # Field name made lowercase.
    team = models.CharField(max_length=255)
    position = models.CharField(max_length=255)
    age = models.IntegerField()
    email = models.CharField(max_length=255)
    datehired = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'hrdb'
        unique_together = (('empnum', 'mac'),)


class Logonoff(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    logtype = models.CharField(max_length=255)
    eventid = models.IntegerField(db_column='eventID')  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ssid = models.CharField(db_column='SSID', max_length=255)  # Field name made lowercase.
    suname = models.CharField(db_column='SUname', max_length=255)  # Field name made lowercase.
    sdname = models.CharField(db_column='SDname', max_length=255)  # Field name made lowercase.
    slogonid = models.CharField(db_column='SlogonID', max_length=255)  # Field name made lowercase.
    tsid = models.CharField(db_column='TSID', max_length=255)  # Field name made lowercase.
    tuname = models.CharField(db_column='TUname', max_length=255)  # Field name made lowercase.
    tdname = models.CharField(db_column='TDname', max_length=255)  # Field name made lowercase.
    tlogonid = models.CharField(db_column='TlogonID', max_length=255)  # Field name made lowercase.
    failurecode = models.CharField(max_length=255)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'logonoff'


class Oafile(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    accessmask = models.CharField(max_length=255)
    eventid = models.IntegerField(db_column='eventID')  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    sid = models.CharField(db_column='SID', max_length=255)  # Field name made lowercase.
    logonid = models.CharField(db_column='logonID', max_length=255)  # Field name made lowercase.
    dname = models.CharField(db_column='Dname', max_length=255)  # Field name made lowercase.
    objserver = models.CharField(max_length=255)
    root = models.CharField(max_length=255)
    directory = models.CharField(max_length=255)
    file = models.CharField(max_length=255)
    ext = models.CharField(max_length=10)
    psname = models.CharField(db_column='PSname', max_length=255)  # Field name made lowercase.
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'oafile'


class Oamtp(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    accessmask = models.CharField(max_length=255)
    eventid = models.IntegerField(db_column='eventID')  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    sid = models.CharField(db_column='SID', max_length=255)  # Field name made lowercase.
    logonid = models.CharField(db_column='logonID', max_length=255)  # Field name made lowercase.
    dname = models.CharField(db_column='Dname', max_length=255)  # Field name made lowercase.
    objserver = models.CharField(max_length=255)
    objname = models.CharField(max_length=255)
    ext = models.CharField(max_length=10)
    psname = models.CharField(db_column='PSname', max_length=255)  # Field name made lowercase.
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'oamtp'


class PartWin10(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    sid = models.CharField(db_column='SID', max_length=255)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    eventid = models.IntegerField(db_column='EventID')  # Field name made lowercase.
    disknum = models.IntegerField(db_column='diskNum')  # Field name made lowercase.
    diskid = models.CharField(db_column='diskID', max_length=255)  # Field name made lowercase.
    characteristics = models.CharField(max_length=255)
    bustype = models.CharField(max_length=255)
    manufacturer = models.CharField(max_length=255)
    model = models.CharField(max_length=255)
    modelversion = models.CharField(max_length=255)
    serialnum = models.CharField(db_column='SerialNum', max_length=255)  # Field name made lowercase.
    parentid = models.CharField(db_column='parentID', max_length=255)  # Field name made lowercase.
    registryid = models.CharField(db_column='registryID', max_length=255)  # Field name made lowercase.
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'part_win10'


class Qscan(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    fname = models.CharField(db_column='Fname', max_length=255)  # Field name made lowercase.
    ext = models.CharField(max_length=10)
    fnum = models.IntegerField(db_column='Fnum')  # Field name made lowercase.
    datetime = models.CharField(max_length=20)
    curs = models.CharField(max_length=5)

    class Meta:
        managed = False
        db_table = 'qscan'


class Reg(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    devicedesc = models.CharField(max_length=255)
    hardwareid = models.CharField(db_column='hardwareID', max_length=255)  # Field name made lowercase.
    compatibleids = models.CharField(max_length=255)
    driver = models.CharField(max_length=255)
    mfg = models.CharField(max_length=255)
    service = models.CharField(max_length=255)
    friendlyname = models.CharField(max_length=255)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'reg'

class SbtProtectionAct(models.Model):
    article = models.CharField(max_length=50)
    contents = models.TextField()

    class Meta:
        managed = False
        db_table = 'sbt_protection_act'

class UactivReportSaves(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    wdate = models.CharField(db_column='Wdate', max_length=20)  # Field name made lowercase.
    empnum = models.IntegerField(db_column='EMPnum')  # Field name made lowercase.
    empname = models.CharField(db_column='EMPname', max_length=20)  # Field name made lowercase.
    center_team = models.CharField(max_length=255)
    position = models.CharField(max_length=10)
    reasontype = models.CharField(max_length=10)
    lognum = models.IntegerField()
    logtable = models.CharField(max_length=20)
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    outflow_file = models.CharField(db_column='outflow_File', max_length=255)  # Field name made lowercase.
    url_link = models.CharField(db_column='url_Link', max_length=255, blank=True, null=True)  # Field name made lowercase.
    model = models.CharField(max_length=255, blank=True, null=True)
    owner = models.CharField(max_length=255, blank=True, null=True)
    source = models.CharField(max_length=255, blank=True, null=True)
    application = models.CharField(max_length=255, blank=True, null=True)
    receiver = models.CharField(max_length=255)
    rf_outflow_file = models.CharField(db_column='rf_outflow_File', max_length=255)  # Field name made lowercase.
    rf_outflow_file_detail = models.TextField(db_column='rf_outflow_File_detail')  # Field name made lowercase.
    upfilename = models.FileField(upload_to='documents/')
    violation = models.CharField(max_length=255, blank=True, null=True)
    severity = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'uactiv_report_saves'


class UactivReportSend(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    empnum = models.ForeignKey(Hrdb, models.DO_NOTHING, db_column='EMPnum')  # Field name made lowercase.
    lognum = models.IntegerField()
    reasontype = models.CharField(max_length=10)
    logtable = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'uactiv_report_send'


class Zscan(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    cdatetime = models.CharField(db_column='Cdatetime', max_length=40)  # Field name made lowercase.
    adatetime = models.CharField(db_column='Adatetime', max_length=40)  # Field name made lowercase.
    mdatetime = models.CharField(db_column='Mdatetime', max_length=40)  # Field name made lowercase.
    size_kb = models.CharField(db_column='size_KB', max_length=255)  # Field name made lowercase.
    rootdir = models.CharField(max_length=255)
    dirname = models.CharField(max_length=255)
    fname = models.CharField(db_column='Fname', max_length=255)  # Field name made lowercase.
    basename = models.CharField(max_length=255)
    ext = models.CharField(max_length=10)
    attrib = models.CharField(max_length=255)
    srcname = models.CharField(db_column='srCname', max_length=255)  # Field name made lowercase.
    srcext = models.CharField(max_length=255)
    srcsize = models.CharField(max_length=255)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'zscan'

class WeekReportSaves(models.Model):
    title = models.CharField(max_length=255)
    summary = models.CharField(max_length=255)
    wdatetime = models.CharField(max_length=40)
    type_rank = models.CharField(max_length=50)
    severity_cnt = models.CharField(max_length=50)
    top5 = models.CharField(max_length=100)
    violator = models.CharField(max_length=50)
    web_file = models.CharField(max_length=100)
    usb_file = models.CharField(max_length=100)
    app_file = models.CharField(max_length=100)
    outreason = models.CharField(max_length=50)
    accumulate_cnt = models.CharField(max_length=10)
    measure = models.TextField()
    graph_name = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'week_report_saves'