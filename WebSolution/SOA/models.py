from __future__ import unicode_literals
from django.db import models

# Create your models here.
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

class Employee(models.Model):
    e_num = models.IntegerField(primary_key=True)
    ename = models.CharField(max_length=30)
    team = models.CharField(max_length=30)
    ip = models.CharField(max_length=16)
    mac = models.CharField(max_length=18)

    class Meta:
        managed = False
        db_table = 'employee'

class FileLog(models.Model):
    username = models.CharField(max_length=30)
    userdomain = models.CharField(max_length=30)
    computername = models.CharField(max_length=30)
    ipaddress = models.CharField(max_length=16)
    macaddress = models.CharField(max_length=18)
    creationtime = models.CharField(max_length=20)
    lastaccesstime = models.CharField(max_length=20)
    lastwritetime = models.CharField(max_length=20)
    size = models.CharField(max_length=20)
    fullname = models.TextField()

    class Meta:
        managed = False
        db_table = 'file_log'

class ChromeHistory(models.Model):
    cname = models.CharField(max_length=30)
    uname = models.CharField(max_length=30)
    ip = models.CharField(max_length=16)
    mac = models.CharField(max_length=18)
    vtime = models.CharField(max_length=30)
    lvtime = models.CharField(max_length=30)
    url = models.CharField(max_length=255)
    sitename = models.CharField(max_length=255)
    vcount = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'chrome_history'



class Reason(models.Model):
    wdate = models.CharField(max_length=30)
    team = models.CharField(max_length=30)
    ename = models.CharField(max_length=30)
    e_num = models.IntegerField()
    ip = models.CharField(max_length=16)
    mac = models.CharField(max_length=18)
    site = models.CharField(max_length=255)
    reason = models.CharField(max_length=255)
    detail = models.TextField()
    filename = models.FileField(upload_to='documents/')
    reason_num = models.CharField(max_length=10)
    log_num = models.CharField(max_length=10)
    violation = models.CharField(max_length=10, blank=True, null=True)
    severity = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'reason'

class Hrdb(models.Model):
    empnum = models.AutoField(db_column='EMPnum', primary_key=True)  # Field name made lowercase.
    empname = models.CharField(db_column='EMPname', max_length=20)  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=40)  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    center = models.CharField(max_length=10)
    teamnum = models.IntegerField(db_column='teamNum')  # Field name made lowercase.
    team = models.CharField(max_length=10)
    position = models.CharField(max_length=10)
    age = models.IntegerField()
    email = models.CharField(max_length=255)
    datehired = models.DateField()

    class Meta:
        managed = False
        db_table = 'hrdb'
        unique_together = (('empnum', 'mac'),)


class ReasonMember(models.Model):
    e_num = models.ForeignKey(Hrdb, models.DO_NOTHING, db_column='e_num')
    log_num = models.CharField(max_length=10)
    reason_num = models.CharField(max_length=10)

    class Meta:
        managed = False
        db_table = 'reason_member'

class ObjAccessLog(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    accessmask = models.CharField(max_length=255)
    eventid = models.IntegerField(db_column='eventID')  # Field name made lowercase.
    cname = models.CharField(db_column='Cname', max_length=40)  # Field name made lowercase.
    uname = models.CharField(db_column='Uname', max_length=40)  # Field name made lowercase.
    adate = models.DateField(db_column='Adate')  # Field name made lowercase.
    atime = models.TimeField(db_column='Atime')  # Field name made lowercase.
    sid = models.CharField(db_column='SID', max_length=255)  # Field name made lowercase.
    logonid = models.CharField(db_column='logonID', max_length=30)  # Field name made lowercase.
    domainname = models.CharField(max_length=255)
    objserver = models.CharField(max_length=255)
    objname = models.CharField(max_length=255)
    psname = models.CharField(db_column='PSname', max_length=255)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'obj_access_log'

class UactivReports(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    wdate = models.CharField(db_column='Wdate', max_length=10)  # Field name made lowercase.
    empnum = models.IntegerField(db_column='EMPnum')  # Field name made lowercase.
    empname = models.CharField(db_column='EMPname', max_length=20)  # Field name made lowercase.
    center_team = models.CharField(max_length=20)
    log_table = models.CharField(max_length=20)
    log_id = models.IntegerField(db_column='log_ID')  # Field name made lowercase.
    ip = models.CharField(db_column='IP', max_length=20)  # Field name made lowercase.
    mac = models.CharField(db_column='MAC', max_length=17)  # Field name made lowercase.
    outflow_file = models.CharField(db_column='outflow_File', max_length=255)  # Field name made lowercase.
    url_link = models.CharField(db_column='url_Link', max_length=255, blank=True, null=True)  # Field name made lowercase.
    model = models.CharField(max_length=50, blank=True, null=True)
    owner = models.CharField(max_length=40, blank=True, null=True)
    source = models.CharField(max_length=50, blank=True, null=True)
    application = models.CharField(max_length=50, blank=True, null=True)
    receiver = models.CharField(max_length=50, blank=True, null=True)
    rf_outflow_file = models.CharField(db_column='rf_outflow_File', max_length=50)  # Field name made lowercase.
    rf_outflow_file_detail = models.TextField(db_column='rf_outflow_File_detail')  # Field name made lowercase.
    upfilename = models.FileField(upload_to='documents/')
    violation = models.CharField(max_length=10, blank=True, null=True)
    severity = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'uactiv_reports'