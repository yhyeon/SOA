from django.shortcuts import render, redirect, render_to_response
from django.http import HttpResponse
from django.contrib.auth import authenticate, login, logout
from .forms import *
from SOA.models import *
from django.db.models import Q
from django.views.decorators.csrf import csrf_exempt
from django.template import RequestContext
import math
from datetime import datetime

# Create your views here.
def paging(totalCnt, currentPage):
    rowsPerData = 15
    rowsPerPage = 10
    totalPageList = []

    if ((totalCnt % rowsPerData) == 0):
        totalPages = int(totalCnt / rowsPerData)
    else:
        totalPages = int(totalCnt / rowsPerData) + 1

    if (currentPage <= 0):
        currentPage = 1
    if (currentPage >= totalPages):
        currentPage = totalPages

    currentBlock = math.ceil(currentPage / rowsPerPage) - 1
    startBlock = ((currentBlock) * rowsPerPage) + 1
    endBlock = startBlock + rowsPerPage - 1
    if (endBlock > totalPages):
        endBlock = totalPages

    for i in range(int(startBlock), int(endBlock) + 1):
        totalPageList.append(i)

    if (currentBlock <= 0):
        prev = 0
    else:
        prev = 1
    if (currentBlock >= int(totalPages / rowsPerPage)):
        next = 0
    else:
        next = 1

    return totalPageList, prev, next

def user_login(request):
    form = LoginForm()
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            cd = form.cleaned_data
            user = authenticate(username=cd['username'], password=cd['password'])
            if user is not None:
                if user.is_active:
                    login(request, user)
                    request.session['username'] = cd['username']
                    #return HttpResponse('Authenticated', 'successfully') #성공
                    #return render(request, 'home.html', {'username':cd['username']})
                    return redirect('home')
                else:
                    return HttpResponse('Disabled account')
            else:
                #return HttpResponse('Invalid login') #실패
                return render(request, 'login.html', {'message': 'Login File!'})
        else:
            form = LoginForm()
    return render(request, 'login.html', {})

def user_logout(request):
    del request.session['username']
    logout(request)
    return redirect('login')

def home(request):
    return render(request, 'home.html', {'username':request.session['username']})


# Logs tab
@csrf_exempt
def beginning(request):
    if request.POST.get('page'):
        currentPage = int(request.POST.get('page'))
    else:
        currentPage = 1
    rowsPerData = 15
    rowsPerPage = 10
    totalCnt = 0
    dataList = []
    totalPageList = []

    if request.POST.get('prev'):
        currentPage = int(request.POST.get('prev'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock - 1) * rowsPerPage) + 1
    if request.POST.get('next'):
        currentPage = int(request.POST.get('next'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock + 1) * rowsPerPage) + 1

    start_pos = (currentPage - 1) * rowsPerData
    end_pos = start_pos + rowsPerData

    if request.POST.get('search_data'):
        search_data = '%s' % request.POST.get('search_data')
        totalCnt = FileLog.objects.filter(Q(id=search_data) | Q(username=search_data) | Q(userdomain=search_data) | Q(computername=search_data) | Q(ipaddress=search_data) | Q(macaddress=search_data) | Q(creationtime=search_data) | Q(lastaccesstime=search_data) | Q(lastwritetime=search_data) | Q(size=search_data) | Q(fullname=search_data)).count()
        dataList = FileLog.objects.filter(Q(id=search_data) | Q(username=search_data) | Q(userdomain=search_data) | Q(computername=search_data) | Q(ipaddress=search_data) | Q(macaddress=search_data) | Q(creationtime=search_data) | Q(lastaccesstime=search_data) | Q(lastwritetime=search_data) | Q(size=search_data) | Q(fullname=search_data))[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('beginning.html',{'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList,'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

    else:
        totalCnt = FileLog.objects.all().count()
        dataList = FileLog.objects.all()[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('beginning.html',{'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList,'prev': prev, 'next': next}, RequestContext(request))

def outflowsign(request):
    pass

def outflowaction(request):
    pass

def leavesign(request):
    pass

# Reason tab
@csrf_exempt
def waiting(request):
    if request.POST.get('page'):
        currentPage = int(request.POST.get('page'))
    else:
        currentPage = 1
    rowsPerData = 15
    rowsPerPage = 10
    totalCnt = 0
    dataList = []
    totalPageList = []

    if request.POST.get('prev'):
        currentPage = int(request.POST.get('prev'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock - 1) * rowsPerPage) + 1
    if request.POST.get('next'):
        currentPage = int(request.POST.get('next'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock + 1) * rowsPerPage) + 1

    start_pos = (currentPage - 1) * rowsPerData
    end_pos = start_pos + rowsPerData

    if request.POST.get('search_data'):
        search_data = '%s' % request.POST.get('search_data')
        totalCnt = ReasonMember.objects.select_related().filter(Q(id=search_data) | Q(e_num__empnum=search_data) | Q(e_num__empname=search_data) | Q(e_num__ip=search_data) | Q(log_num=search_data) | Q(reason_num=search_data)).count()
        dataList = ReasonMember.objects.select_related().filter(Q(id=search_data) | Q(e_num__empnum=search_data) | Q(e_num__empname=search_data) | Q(e_num__ip=search_data) | Q(log_num=search_data) | Q(reason_num=search_data)).all()[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('reason_waiting.html',{'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList,'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

    else:
        totalCnt = ReasonMember.objects.select_related().all().count()
        dataList = ReasonMember.objects.select_related().all()[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('reason_waiting.html',{'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList,'prev': prev, 'next': next}, RequestContext(request))

@csrf_exempt
def process(request):
    if request.POST.get('violation'):
        rs = UactivReports.objects.get(pk = request.POST.get('id'))
        if request.POST.get('severity'):
            rs.violation = request.POST.get('violation')
            rs.severity = request.POST.get('severity')
        else:
            rs.violation = request.POST.get('violation')
        rs.save()

    if request.POST.get('page'):
        currentPage = int(request.POST.get('page'))
    else:
        currentPage = 1
    rowsPerData = 15
    rowsPerPage = 10
    totalCnt = 0
    dataList = []
    totalPageList = []

    if request.POST.get('prev'):
        currentPage = int(request.POST.get('prev'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock - 1) * rowsPerPage) + 1
    if request.POST.get('next'):
        currentPage = int(request.POST.get('next'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock + 1) * rowsPerPage) + 1

    start_pos = (currentPage - 1) * rowsPerData
    end_pos = start_pos + rowsPerData

    if request.POST.get('search_data'):
        search_data = '%s' % request.POST.get('search_data')
        totalCnt = UactivReports.objects.filter((Q(id=int(search_data)) | Q(center_team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(log_table=search_data) | Q(log_id=search_data) | Q(wdate=search_data)) & Q(violation=None)).count()
        dataList = UactivReports.objects.filter((Q(id=int(search_data)) | Q(team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(log_table=search_data) | Q(log_id=search_data) | Q(wdate=search_data)) & Q(violation=None)).all()[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('reason_process.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

    else:
        totalCnt = UactivReports.objects.filter(violation = None).count()
        dataList = UactivReports.objects.filter(violation = None)[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('reason_process.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))

@csrf_exempt
def reason_check(request, reason_id):
    reasonData = UactivReports.objects.get(id=reason_id)

    return render_to_response('reason_check.html', {'username':request.session['username'], 'reasonData':reasonData}, RequestContext(request))

@csrf_exempt
def complete(request):
    if request.POST.get('page'):
        currentPage = int(request.POST.get('page'))
    else:
        currentPage = 1
    rowsPerData = 15
    rowsPerPage = 10
    totalCnt = 0
    dataList = []
    totalPageList = []

    if request.POST.get('prev'):
        currentPage = int(request.POST.get('prev'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock - 1) * rowsPerPage) + 1
    if request.POST.get('next'):
        currentPage = int(request.POST.get('next'))
        currentBlock = math.ceil(currentPage / rowsPerPage) - 1
        currentPage = ((currentBlock + 1) * rowsPerPage) + 1

    start_pos = (currentPage - 1) * rowsPerData
    end_pos = start_pos + rowsPerData

    if request.POST.get('search_data'):
        search_data = '%s' % request.POST.get('search_data')
        totalCnt = UactivReports.objects.filter((Q(id=int(search_data)) | Q(center_team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(log_table=search_data) | Q(log_id=search_data) | Q(wdate=search_data)) & Q(violation=None)).count()
        dataList = UactivReports.objects.filter((Q(id=int(search_data)) | Q(center_team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(log_table=search_data) | Q(log_id=search_data) | Q(wdate=search_data)) & Q(violation=None)).all()[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('reason_complete.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

    else:
        totalCnt = UactivReports.objects.filter(~Q(violation = None)).count()
        dataList = UactivReports.objects.filter(~Q(violation = None))[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('reason_complete.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))

@csrf_exempt
def reason_view(request, reason_id):
    reasonData = UactivReports.objects.get(id=reason_id)

    return render(request, 'reason_view.html', {'username': request.session['username'], 'reasonData': reasonData})

# Report tab
def report(request):
    return render(request, 'report.html', {'username': request.session['username']})

def report_pop(request):
    return render(request, 'report_pop.html', {})

def report_new(request):
    return render(request, 'report_new.html', {'username': request.session['username']})

def report_process(request):
    t = ['월', '화', '수', '목', '금', '토', '일']
    prevdate = datetime(int(request.POST.get('pdate').split('/')[0]), int(request.POST.get('pdate').split('/')[1]), int(request.POST.get('pdate').split('/')[2]))
    nextdate = datetime(int(request.POST.get('ndate').split('/')[0]), int(request.POST.get('ndate').split('/')[1]), int(request.POST.get('ndate').split('/')[2]))

    print(str(prevdate.date()))
    print(nextdate.date())

    reason_totalCnt = UactivReports.objects.filter(wdate=prevdate.date()).count()
    vioCnt = UactivReports.objects.filter(wdate=prevdate.date(),violation='위반').count()
    bisCnt = UactivReports.objects.filter(wdate=prevdate.date(), violation='업무').count()
    replyCnt = vioCnt + bisCnt

    return render(request, 'report_write.html', {'username': request.session['username'], 'rMonth': request.POST.get('rMonth'), 'rWeek': request.POST.get('rWeek'), 'pMonth': prevdate.month, 'pDay': prevdate.day, 'pDow': t[prevdate.weekday()],
                                                 'nMonth': nextdate.month, 'nDay': nextdate.day, 'nDow': t[nextdate.weekday()], 'reason_totalCnt': reason_totalCnt, 'vioCnt': vioCnt, 'bisCnt': bisCnt, 'replyCnt': replyCnt})

# Guideline tab
def statute(request):
    pass

def case(request):
    return render(request, 'home.html', {'username': request.session['username']})
    pass

def preventive(request):
    pass

def communication(request):
    pass

# Employee tab
def employee(request):
    pass

# Setting tab
def account(request):
    pass

def solution(request):
    pass

# Support tab
def support(request):
    pass

# Employees reason
def e_login(request):
    form = ELoginForm()
    if request.method == 'POST':
        form = ELoginForm(request.POST)
        if form.is_valid():
            cd = form.cleaned_data
            if ReasonMember.objects.filter(e_num=int(cd['e_num']), log_num=cd['log_num']):
                user = ReasonMember.objects.get(e_num=int(cd['e_num']), log_num=cd['log_num'])

                request.session['e_num'] = cd['e_num']
                request.session['log_num'] = cd['log_num']
                request.session['reason_num'] = user.reason_num

                if user.reason_num == '1':
                    print('usb Tab')
                    return redirect('usb')
                elif user.reason_num == '2':
                    print('web Tab')
                    return redirect('web')
                elif user.reason_num == 'obj_access':
                    print('application Tab')
                    return redirect('application')
            else:
                return render(request, 'e_login.html', {'message': 'Login Fail!'})
        else:
            form = ELoginForm()
    return render(request, 'e_login.html', {})

@csrf_exempt
def e_usb(request):
    return render(request, 'e_usb.html', {})

@csrf_exempt
def e_web(request):
    site = []

    dt = datetime.now()
    nowdate = str(dt.today().year) + '/' + str(dt.today().month) + '/' + str(dt.today().day)

    employee = Employee.objects.get(e_num=request.session['e_num'])
    log_id = request.session['log_num']
    if request.session['reason_num'] == '2':
        site = ChromeHistory.objects.get(id=int(log_id))

    return render_to_response('e_web.html', {'nowdate': nowdate, 'employee':employee, 'site':site}, RequestContext(request))

@csrf_exempt
def e_application(request):
    dt = datetime.now()
    nowdate = str(dt.today().year) + '/' + str(dt.today().month) + '/' + str(dt.today().day)

    employee = Hrdb.objects.get(empnum=request.session['e_num'])
    log_id = request.session['log_num']
    logData = ObjAccessLog.objects.get(id=int(log_id))

    return render(request, 'e_application.html', {'nowdate':nowdate, 'employee':employee, 'logData':logData}, RequestContext(request))

@csrf_exempt
def e_success(request):
    dt = datetime.now()
    nowdate = str(dt.today().year) + '/' + str(dt.today().month) + '/' + str(dt.today().day)

    if request.method == 'POST':
        if request.FILES:
            files = request.FILES['file']
            if request.POST.get('site'):
                new = UactivReports(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('name'), empnum=int(request.POST.get('enum')), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), url_link=request.POST.get('site'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), upfilename=files, log_id=request.session['log_num'], log_table=request.session['reason_num'])
            elif request.POST.get('model'):
                new = UactivReports(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('name'), empnum=int(request.POST.get('enum')), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), model=request.POST.get('model'), owner=request.POST.get('owner'), source=request.POST.get('source'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), upfilename=files, log_id=request.session['log_num'], log_table=request.session['reason_num'])
            elif request.POST.get('application'):
                new = UactivReports(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('name'), empnum=int(request.POST.get('enum')), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), application=request.POST.get('application'), receiver=request.POST.get('receiver'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), upfilename=files, log_id=request.session['log_num'], log_table=request.session['reason_num'])

            new.save()

            delReasonMember = ReasonMember.objects.get(e_num=int(request.POST.get('enum')), log_num=request.session['log_num'])
            delReasonMember.delete()
        else:
            if request.POST.get('site'):
                new = UactivReports(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('name'), empnum=int(request.POST.get('enum')), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), url_link=request.POST.get('site'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), log_id=request.session['log_num'], log_table=request.session['reason_num'])
            elif request.POST.get('model'):
                new = UactivReports(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('name'), empnum=int(request.POST.get('enum')), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), model=request.POST.get('model'), owner=request.POST.get('owner'), source=request.POST.get('source'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), log_id=request.session['log_num'], log_table=request.session['reason_num'])
            elif request.POST.get('application'):
                new = UactivReports(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('name'), empnum=int(request.POST.get('enum')),
                                    ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'),
                                    application=request.POST.get('application'), receiver=request.POST.get('receiver'), rf_outflow_file=request.POST.get('reason'),
                                    rf_outflow_file_detail=request.POST.get('detail'), log_id=int(request.session['log_num']), log_table=request.session['reason_num'])

            new.save()

            delReasonMember = ReasonMember.objects.get(e_num=int(request.POST.get('enum')), log_num=request.session['log_num'])
            delReasonMember.delete()

    return render(request, 'e_success.html', {})
