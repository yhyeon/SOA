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
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    window = models.CharField(max_length=255, blank=True, null=True)
    process = models.CharField(max_length=255, blank=True, null=True)
    starttime = models.CharField(max_length=40, blank=True, null=True)
    datetime = models.CharField(max_length=40, blank=True, null=True)
    curs = models.CharField(max_length=5, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'clip_proc'

class Clipf(models.Model):
    disksn = models.CharField(db_column='DiskSN', max_length=255, blank=True, null=True)  # Field name made lowercase.
    fname = models.CharField(max_length=255, blank=True, null=True)
    mtime = models.CharField(max_length=255, blank=True, null=True)
    curs = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'clipf'

class ConNet(models.Model):
    teamnum = models.IntegerField(db_column='teamNum')  # Field name made lowercase.
    team = models.CharField(max_length=255)
    mgrname = models.CharField(db_column='MGRname', max_length=20, blank=True, null=True)  # Field name made lowercase.
    telnum = models.CharField(db_column='telNum', max_length=30, blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'con_net'

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
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    guid = models.CharField(db_column='GUID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    current_path = models.CharField(max_length=255, blank=True, null=True)
    target_path = models.CharField(max_length=255, blank=True, null=True)
    datetime = models.CharField(max_length=40, blank=True, null=True)
    received_bytes = models.CharField(max_length=255, blank=True, null=True)
    total_bytes = models.CharField(max_length=255, blank=True, null=True)
    state = models.CharField(max_length=255, blank=True, null=True)
    danger_type = models.CharField(max_length=255, blank=True, null=True)
    interrupt_reason = models.CharField(max_length=255, blank=True, null=True)
    uri = models.CharField(max_length=255, blank=True, null=True)
    url = models.CharField(max_length=255, blank=True, null=True)
    fname = models.CharField(db_column='Fname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ext = models.CharField(max_length=10, blank=True, null=True)
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'down_chrome'


class DriverWin7(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    sid = models.CharField(db_column='SID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    eventid = models.IntegerField(db_column='EventID')  # Field name made lowercase.
    lifetime = models.CharField(max_length=255, blank=True, null=True)
    hostguid = models.CharField(db_column='HostGUID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    device = models.CharField(max_length=255, blank=True, null=True)
    statusinfo = models.CharField(max_length=255, blank=True, null=True)
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'driver_win7'


class Fscan(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    cdatetime = models.CharField(db_column='Cdatetime', max_length=40, blank=True, null=True)  # Field name made lowercase.
    adatetime = models.CharField(db_column='Adatetime', max_length=40, blank=True, null=True)  # Field name made lowercase.
    mdatetime = models.CharField(db_column='Mdatetime', max_length=40, blank=True, null=True)  # Field name made lowercase.
    size_kb = models.FloatField(db_column='size_KB')  # Field name made lowercase.
    rootdir = models.CharField(max_length=255, blank=True, null=True)
    dirname = models.CharField(max_length=255, blank=True, null=True)
    fname = models.CharField(db_column='Fname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    basename = models.CharField(max_length=255, blank=True, null=True)
    ext = models.CharField(max_length=10, blank=True, null=True)
    attrib = models.CharField(max_length=255, blank=True, null=True)
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'fscan'


class HistChrome(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    lvdatetime = models.CharField(db_column='LVdatetime', max_length=40, blank=True, null=True)  # Field name made lowercase.
    uri = models.CharField(max_length=255, blank=True, null=True)
    url = models.CharField(max_length=255, blank=True, null=True)
    site_name = models.CharField(max_length=255, blank=True, null=True)
    vcount = models.IntegerField(db_column='Vcount')  # Field name made lowercase.
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'hist_chrome'


class HistIe(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    uri = models.CharField(max_length=255, blank=True, null=True)
    url = models.CharField(max_length=255, blank=True, null=True)
    sname = models.CharField(db_column='Sname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'hist_ie'


class Hrdb(models.Model):
    empnum = models.IntegerField(db_column='EMPnum', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    empname = models.CharField(db_column='EMPname', max_length=20, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    center = models.CharField(max_length=255, blank=True, null=True)
    teamnum = models.IntegerField(db_column='teamNum')  # Field name made lowercase.
    team = models.CharField(max_length=255, blank=True, null=True)
    position = models.CharField(max_length=255, blank=True, null=True)
    age = models.IntegerField()
    email = models.CharField(max_length=255, blank=True, null=True)
    datehired = models.CharField(max_length=20)
    secretkey = models.CharField(db_column='secretKey', max_length=16, blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'hrdb'
        unique_together = (('empnum', 'mac'),)


class Logonoff(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    logtype = models.CharField(max_length=255, blank=True, null=True)
    eventid = models.IntegerField(db_column='EventID')  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ssid = models.CharField(db_column='SSID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    suname = models.CharField(db_column='SUname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    sdname = models.CharField(db_column='SDname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    slogonid = models.CharField(db_column='SlogonID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    tsid = models.CharField(db_column='TSID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    tuname = models.CharField(db_column='TUname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    tdname = models.CharField(db_column='TDname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    tlogonid = models.CharField(db_column='TlogonID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    failurecode = models.CharField(max_length=255, blank=True, null=True)
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'logonoff'


class Oafile(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    accessmask = models.CharField(max_length=255, blank=True, null=True)
    eventid = models.IntegerField(db_column='EventID')  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    sid = models.CharField(db_column='SID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    logonid = models.CharField(db_column='logonID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    dname = models.CharField(db_column='Dname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    objserver = models.CharField(max_length=255, blank=True, null=True)
    root = models.CharField(max_length=255, blank=True, null=True)
    directory = models.CharField(max_length=255, blank=True, null=True)
    file = models.CharField(max_length=255, blank=True, null=True)
    ext = models.CharField(max_length=10, blank=True, null=True)
    psname = models.CharField(db_column='PSname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'oafile'


class Oamtp(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    accessmask = models.CharField(max_length=255, blank=True, null=True)
    eventid = models.IntegerField(db_column='EventID')  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    sid = models.CharField(db_column='SID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    logonid = models.CharField(db_column='logonID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    dname = models.CharField(db_column='Dname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    objserver = models.CharField(max_length=255, blank=True, null=True)
    objname = models.CharField(max_length=255, blank=True, null=True)
    ext = models.CharField(max_length=10, blank=True, null=True)
    psname = models.CharField(db_column='PSname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'oamtp'


class PartWin10(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    sid = models.CharField(db_column='SID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    eventid = models.IntegerField(db_column='EventID')  # Field name made lowercase.
    disknum = models.IntegerField(db_column='diskNum')  # Field name made lowercase.
    diskid = models.CharField(db_column='diskID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    characteristics = models.CharField(max_length=255, blank=True, null=True)
    bustype = models.CharField(max_length=255, blank=True, null=True)
    manufacturer = models.CharField(max_length=255, blank=True, null=True)
    model = models.CharField(max_length=255, blank=True, null=True)
    modelversion = models.CharField(max_length=255, blank=True, null=True)
    serialnum = models.CharField(db_column='SerialNum', max_length=255, blank=True, null=True)  # Field name made lowercase.
    parentid = models.CharField(db_column='parentID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    registryid = models.CharField(db_column='registryID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'part_win10'


class Qscan(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    fname = models.CharField(db_column='Fname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ext = models.CharField(max_length=10, blank=True, null=True)
    fnum = models.IntegerField(db_column='Fnum')  # Field name made lowercase.
    datetime = models.CharField(max_length=40, blank=True, null=True)
    curs = models.CharField(max_length=5, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'qscan'


class Reg(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    devicedesc = models.CharField(max_length=255, blank=True, null=True)
    hardwareid = models.CharField(db_column='hardwareID', max_length=255, blank=True, null=True)  # Field name made lowercase.
    compatibleids = models.CharField(max_length=255, blank=True, null=True)
    driver = models.CharField(max_length=255, blank=True, null=True)
    mfg = models.CharField(max_length=255, blank=True, null=True)
    service = models.CharField(max_length=255, blank=True, null=True)
    friendlyname = models.CharField(max_length=255, blank=True, null=True)
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'reg'

class SbtItpAct(models.Model):
    article = models.CharField(max_length=50)
    contents = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sbt_itp_act'

class SbtPreventUc(models.Model):
    article = models.CharField(max_length=50)
    contents = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sbt_prevent_uc'

class SbtProtectionAct(models.Model):
    article = models.CharField(max_length=50)
    contents = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sbt_protection_act'

class SbtWwCooperation(models.Model):
    article = models.CharField(max_length=50)
    contents = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sbt_ww_cooperation'

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
    ip = models.CharField(db_column='IP', max_length=15)  # Field name made lowercase.
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


class WeekReportSaves(models.Model):
    title = models.CharField(max_length=255)
    summary = models.CharField(max_length=255)
    wdatetime = models.CharField(max_length=40)
    type_rank = models.CharField(max_length=50)
    severity_cnt = models.CharField(max_length=50)
    top5 = models.CharField(max_length=100)
    violator = models.CharField(max_length=50)
    web_file = models.CharField(max_length=100, blank=True, null=True)
    usb_file = models.CharField(max_length=100, blank=True, null=True)
    app_file = models.CharField(max_length=100, blank=True, null=True)
    outreason = models.CharField(max_length=50)
    accumulate_cnt = models.CharField(max_length=10)
    measure = models.TextField()
    graph_name = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'week_report_saves'


class Zscan(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100, blank=True, null=True)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15, blank=True, null=True)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17, blank=True, null=True)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    cdatetime = models.CharField(db_column='Cdatetime', max_length=40, blank=True, null=True)  # Field name made lowercase.
    adatetime = models.CharField(db_column='Adatetime', max_length=40, blank=True, null=True)  # Field name made lowercase.
    mdatetime = models.CharField(db_column='Mdatetime', max_length=40, blank=True, null=True)  # Field name made lowercase.
    size_kb = models.FloatField(db_column='size_KB')  # Field name made lowercase.
    rootdir = models.CharField(max_length=255, blank=True, null=True)
    dirname = models.CharField(max_length=255, blank=True, null=True)
    fname = models.CharField(db_column='Fname', max_length=255, blank=True, null=True)  # Field name made lowercase.
    basename = models.CharField(max_length=255, blank=True, null=True)
    ext = models.CharField(max_length=10, blank=True, null=True)
    attrib = models.CharField(max_length=255, blank=True, null=True)
    srcname = models.CharField(max_length=255, blank=True, null=True)
    srcext = models.CharField(max_length=255, blank=True, null=True)
    srcsize = models.FloatField()
    curs = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'zscan'

class Mft(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    recordnum = models.CharField(db_column='RecordNum', max_length=255)  # Field name made lowercase.
    precordnum = models.CharField(db_column='PRecordNum', max_length=255)  # Field name made lowercase.
    pfsequencenum = models.CharField(db_column='PFSequenceNum', max_length=255)  # Field name made lowercase.
    fsequencenum = models.CharField(db_column='FSequenceNum', max_length=255)  # Field name made lowercase.
    fullname = models.CharField(db_column='FullName', max_length=255)  # Field name made lowercase.
    name = models.CharField(db_column='Name', max_length=255)  # Field name made lowercase.
    directory = models.CharField(db_column='Directory', max_length=255)  # Field name made lowercase.
    deleted = models.CharField(db_column='Deleted', max_length=255)  # Field name made lowercase.
    mtime = models.CharField(max_length=40)
    atime = models.CharField(max_length=40)
    ctime = models.CharField(max_length=40)
    btime = models.CharField(max_length=40)
    fmtime = models.CharField(max_length=40)
    fatime = models.CharField(max_length=40)
    fctime = models.CharField(max_length=40)
    fbtime = models.CharField(max_length=40)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'MFT'

class Archive(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    src_root = models.CharField(max_length=255)
    src_directory = models.CharField(max_length=255)
    src_file = models.CharField(max_length=255)
    src_ext = models.CharField(max_length=10)
    arc_root = models.CharField(max_length=255)
    arc_directory = models.CharField(max_length=255)
    arc_file = models.CharField(max_length=255)
    arc_ext = models.CharField(max_length=10)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'archive'

class Rfile(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    ori_root = models.CharField(max_length=255)
    ori_directory = models.CharField(max_length=255)
    ori_file = models.CharField(max_length=255)
    ori_ext = models.CharField(max_length=10)
    mod_root = models.CharField(max_length=255)
    mod_directory = models.CharField(max_length=255)
    mod_file = models.CharField(max_length=255)
    mod_ext = models.CharField(max_length=10)
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'rfile'

class Usnjrnl(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    disksn = models.CharField(db_column='DiskSN', max_length=100)  # Field name made lowercase.
    udname = models.CharField(db_column='UDname', max_length=255)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=255)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=15)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=255)  # Field name made lowercase.
    vpath = models.CharField(db_column='VPath', max_length=255)  # Field name made lowercase.
    recordnum = models.CharField(db_column='RecordNum', max_length=255)  # Field name made lowercase.
    fsequencenum = models.CharField(db_column='FSequenceNum', max_length=255)  # Field name made lowercase.
    precordnum = models.CharField(db_column='PRecordNum', max_length=255)  # Field name made lowercase.
    pfsequencenum = models.CharField(db_column='PFSequenceNum', max_length=255)  # Field name made lowercase.
    usn = models.CharField(db_column='USN', max_length=255)  # Field name made lowercase.
    datetime = models.CharField(max_length=40)
    reason = models.CharField(db_column='Reason', max_length=255)  # Field name made lowercase.
    fname = models.CharField(db_column='FName', max_length=255)  # Field name made lowercase.
    fattr = models.CharField(db_column='FAttr', max_length=255)  # Field name made lowercase.
    curs = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'usnjrnl'