#-*-coding:utf-8-*-

from django.shortcuts import render, redirect, render_to_response
from django.http import HttpResponse, HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.conf import settings
from .forms import *
from SOA.models import *
from django.db.models import Q
from django.views.decorators.csrf import csrf_exempt
from django.template import RequestContext
import math
from datetime import datetime
from collections import Counter
from django.template.defaultfilters import register
from operator import itemgetter
from django.contrib import messages

# Make Report Graph
import pandas
import matplotlib.pylab as plt
from matplotlib import font_manager, rc
import os

# Make Report PDF
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.units import cm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Flowable
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.graphics.shapes import Image, Drawing

# OTP / QR Code
import pyotp
from random import randint, choice
import base64

# ReCaptcha
import urllib.parse
import urllib.request

from .createPy.searchData import Search
from .createPy.pyDB import DB

# Create your views here.
@register.filter
def get_item(dictionary, key):
    return dictionary.get(key)

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

    if (totalPageList[0] == -9):
        totalPageList = []
        prev = 0
        next = 0

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

                    return redirect('home')
                else:
                    return HttpResponse('Disabled account')
            else:
                return render(request, 'login.html', {'message': 'Login Fail!'})
        else:
            form = LoginForm()
    return render(request, 'login.html', {})

def user_logout(request):
    del request.session['username']
    logout(request)
    return HttpResponseRedirect('/login/')

def home(request):
    if request.user.is_authenticated():
        return render(request, 'home.html', {'username':request.session['username']})
    else:
        return HttpResponseRedirect('/login/')


# Logs tab
@csrf_exempt
def b_file_log(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('fscan', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_file_scan.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Fscan.objects.all().count()
            dataList = Fscan.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_file_scan.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_driver(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('driver_win7', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_driver.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = DriverWin7.objects.all().count()
            dataList = DriverWin7.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_driver.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_download_chrome(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('down_chrome', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_download_chrome.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = DownChrome.objects.all().count()
            dataList = DownChrome.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_download_chrome.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_history_chrome(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('hist_chrome', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_history_chrome.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = HistChrome.objects.all().count()
            dataList = HistChrome.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_history_chrome.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_history_ie(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('hist_ie', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_history_ie.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = HistIe.objects.all().count()
            dataList = HistIe.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_history_ie.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_log_on_off(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('logonoff', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_log_on_off.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Logonoff.objects.all().count()
            dataList = Logonoff.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_log_on_off.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_oa_file(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('oafile', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_oa_file.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Oafile.objects.all().count()
            dataList = Oafile.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_oa_file.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_oa_mtp(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('oamtp', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_oa_mtp.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Oamtp.objects.all().count()
            dataList = Oamtp.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_oa_mtp.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_partition_win10(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('part_win10', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_partition_win10.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = PartWin10.objects.all().count()
            dataList = PartWin10.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_partition_win10.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_quick_scan(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('qscan', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_quick_scan.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Qscan.objects.all().count()
            dataList = Qscan.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_quick_scan.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_registry(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('reg', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_registry.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Reg.objects.all().count()
            dataList = Reg.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_registry.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_zip_scan(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')
            #totalCnt = Zscan.objects.filter(Q(id=search_data) | Q(udname=search_data) | Q(cname=search_data) | Q(ip=search_data) | Q(mac=search_data) | Q(uname=search_data) | Q(cdatetime=search_data) | Q(adatetime=search_data) | Q(mdatetime=search_data) | Q(size_kb=search_data) | Q(rootdir=search_data) | Q(dirname=search_data) | Q(fname=search_data) | Q(basename=search_data) | Q(ext=search_data) | Q(attrib=search_data) | Q(srcname=search_data) | Q(srcext=search_data) | Q(srcsize=search_data)).count()
            #dataList = Zscan.objects.filter(Q(id=search_data) | Q(udname=search_data) | Q(cname=search_data) | Q(ip=search_data) | Q(mac=search_data) | Q(uname=search_data) | Q(cdatetime=search_data) | Q(adatetime=search_data) | Q(mdatetime=search_data) | Q(size_kb=search_data) | Q(rootdir=search_data) | Q(dirname=search_data) | Q(fname=search_data) | Q(basename=search_data) | Q(ext=search_data) | Q(attrib=search_data) | Q(srcname=search_data) | Q(srcext=search_data) | Q(srcsize=search_data))[start_pos:end_pos]

            searchEng = Search()
            db = DB()

            sql = searchEng._search('zscan', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_zip_scan.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Zscan.objects.all().count()
            dataList = Zscan.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_zip_scan.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_rfile(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('rfile', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_rfile.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Rfile.objects.all().count()
            dataList = Rfile.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_rfile.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_mft(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('mft', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_mft.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Mft.objects.all().count()
            dataList = Mft.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_mft.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_usnjrnl(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('usnjrnl', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_usnjrnl.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Usnjrnl.objects.all().count()
            dataList = Usnjrnl.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_usnjrnl.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def b_archive(request):
    if request.user.is_authenticated():
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
            col_type = '%s' % request.POST.get('col_type')
            search_data = '%s' % request.POST.get('search_data')

            searchEng = Search()
            db = DB()

            sql = searchEng._search('archive', col_type, search_data)
            dataList = db.execute(sql)
            totalCnt = len(dataList)

            dataList = list(dataList[start_pos:end_pos])

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_archive.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data, 'col_type': col_type}, RequestContext(request))

        else:
            totalCnt = Archive.objects.all().count()
            dataList = Archive.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('b_archive.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

def outflowsign(request):
    if request.user.is_authenticated():
        return render_to_response('checking.html', {'username': request.session['username']}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

def outflowaction(request):
    if request.user.is_authenticated():
        return render_to_response('checking.html', {'username': request.session['username']}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

def leavesign(request):
    if request.user.is_authenticated():
        return render_to_response('checking.html', {'username': request.session['username']}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

# Reason tab
@csrf_exempt
def waiting(request):
    if request.user.is_authenticated():
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
            totalCnt = UactivReportSend.objects.select_related().filter(Q(id=search_data) | Q(empnum__empnum=search_data) | Q(empnum__empname=search_data) | Q(empnum__ip=search_data) | Q(lognum=search_data) | Q(reasontype=search_data)).count()
            dataList = UactivReportSend.objects.select_related().filter(Q(id=search_data) | Q(empnum__empnum=search_data) | Q(empnum__empname=search_data) | Q(empnum__ip=search_data) | Q(lognum=search_data) | Q(reasontype=search_data)).all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('reason_waiting.html',{'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList,'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

        else:
            totalCnt = UactivReportSend.objects.select_related().all().count()
            dataList = UactivReportSend.objects.select_related().all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('reason_waiting.html',{'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList,'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def process(request):
    if request.user.is_authenticated():
        if request.POST.get('violation'):
            rs = UactivReportSaves.objects.get(pk = request.POST.get('id'))
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
            totalCnt = UactivReportSaves.objects.filter((Q(id=int(search_data)) | Q(center_team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(reasontype=search_data) | Q(lognum=search_data) | Q(wdate=search_data)) & Q(violation=None)).count()
            dataList = UactivReportSaves.objects.filter((Q(id=int(search_data)) | Q(center_team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(reasontype=search_data) | Q(lognum=search_data) | Q(wdate=search_data)) & Q(violation=None)).all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('reason_process.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

        else:
            totalCnt = UactivReportSaves.objects.filter(violation = None).count()
            dataList = UactivReportSaves.objects.filter(violation = None)[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('reason_process.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def reason_check(request, reason_id):
    if request.user.is_authenticated():
        reasonData = UactivReportSaves.objects.get(id=reason_id)

        if reasonData.logtable == 'oafile':
            dataList = Oafile.objects.filter(id=int(reasonData.lognum))
            return render_to_response('reason_check.html', {'username':request.session['username'], 'reasonData':reasonData, 'dataList':dataList}, RequestContext(request))
        else:
            return render_to_response('reason_check.html',{'username': request.session['username'], 'reasonData': reasonData}, RequestContext(request))

    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def complete(request):
    if request.user.is_authenticated():
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
            totalCnt = UactivReportSaves.objects.filter((Q(id=int(search_data)) | Q(center_team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(reasontype=search_data) | Q(lognum=search_data) | Q(wdate=search_data)) & Q(violation=None)).count()
            dataList = UactivReportSaves.objects.filter((Q(id=int(search_data)) | Q(center_team=search_data) | Q(empname=search_data) | Q(empnum=int(search_data)) | Q(reasontype=search_data) | Q(lognum=search_data) | Q(wdate=search_data)) & Q(violation=None)).all().order_by('-id')[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('reason_complete.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

        else:
            totalCnt = UactivReportSaves.objects.filter(~Q(violation = None)).count()
            dataList = UactivReportSaves.objects.filter(~Q(violation = None)).order_by('-id')[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('reason_complete.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def reason_view(request, reason_id):
    if request.user.is_authenticated():
        reasonData = UactivReportSaves.objects.get(id=reason_id)

        return render(request, 'reason_view.html', {'username': request.session['username'], 'reasonData': reasonData})
    else:
        return HttpResponseRedirect('/login/')

# Report tab
def report(request):
    if request.user.is_authenticated():
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
            totalCnt = WeekReportSaves.objects.filter(Q(id=int(search_data)) | Q(title=search_data) | Q(summary=search_data) | Q(wdatetime=search_data)).count()
            dataList = WeekReportSaves.objects.filter(Q(id=int(search_data)) | Q(title=search_data) | Q(summary=search_data) | Q(wdatetime=search_data)).all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('report.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

        else:
            totalCnt = WeekReportSaves.objects.all().count()
            dataList = WeekReportSaves.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

        return render(request, 'report.html', {'username': request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next})
    else:
        return HttpResponseRedirect('/login/')

def report_view(request, report_id):
    if request.user.is_authenticated():
        reportData = WeekReportSaves.objects.get(id=int(report_id))

        return render(request, 'report_view.html', {'username': request.session['username'], 'reportData': reportData, 'report_id': report_id})
    else:
        return HttpResponseRedirect('/login/')

# Make Line
class MKLine(Flowable):
    def __init__(self, width, height=0):
        Flowable.__init__(self)
        self.width = width
        self.height = height

    def __repr__(self):
        return "Line(w=%s)" % self.width

    def draw(self):
        # Draw the line
        self.canv.line(0, self.height, self.width, self.height)

def report_down(request, report_id):
    if request.user.is_authenticated():
        # Get Report Data
        reportData = WeekReportSaves.objects.get(id=int(report_id))

        # Font Settings
        pdfmetrics.registerFont(TTFont("malgun", "malgun.ttf"))
        pdfmetrics.registerFont(TTFont("malgunbd", "malgunbd.ttf"))

        styles = getSampleStyleSheet()
        styles.add(ParagraphStyle(name="Malgun", fontName="malgun"))
        styles.add(ParagraphStyle(name="MalgunB", fontName="malgunbd"))

        # Create Content
        Story = []
        img = os.getcwd()+'\\SOA\\static\\graph\\'+reportData.graph_name
        print(img)
        d = Drawing(0, 0)
        i = Image(370, -410, 12.5 * cm, 7.4 * cm, img)
        d.add(i)
        Story.append(d)

        ptext = u'<font size=24>%s</font>' % (reportData.title)
        Story.append(Paragraph(ptext, styles["MalgunB"]))
        Story.append(Spacer(1, 34))

        line = MKLine(700)
        Story.append(line)
        Story.append(Spacer(1, 12))

        ptext = u'<font size=16>- %s</font>' % (reportData.summary)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 24))

        ptext = u'<font size=14>[특이사항]</font>'
        Story.append(Paragraph(ptext, styles["MalgunB"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>ㆍ유형별 반출 통계 : %s</font>' % (reportData.type_rank)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>ㆍ반출 심각도 통계 : %s</font>' % (reportData.severity_cnt)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>ㆍ보안 위반자 소속 TOP 5 : %s</font>' % (reportData.top5)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 24))

        ptext = u'<font size=14>[주요 위반자]</font>'
        Story.append(Paragraph(ptext, styles["MalgunB"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>ㆍ%s</font>' % (reportData.violator)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>- WEB 반출 파일 : %s</font>' % (reportData.web_file)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>- USB 반출 파일 : %s</font>' % (reportData.usb_file)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>- APP 반출 파일 : %s</font>' % (reportData.app_file)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>- 반출 사유 : %s</font>' % (reportData.outreason)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>- 총 누적 위반 횟수 : %s</font>' % (reportData.accumulate_cnt)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 24))

        ptext = u'<font size=14>[조치사항]</font>'
        Story.append(Paragraph(ptext, styles["MalgunB"]))
        Story.append(Spacer(1, 12))

        ptext = u'<font size=12>ㆍ%s</font>' % (reportData.measure)
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 40))

        line = MKLine(700)
        Story.append(line)
        Story.append(Spacer(1, 12))

        ptext = u'<font size=16>경영지원본부 보안팀</font>'
        Story.append(Paragraph(ptext, styles["Malgun"]))
        Story.append(Spacer(1, 12))

        pdfname = os.getcwd() + '\\SOA\\reportPDF\\' + reportData.graph_name.split('.')[0] + '.pdf'
        doc = SimpleDocTemplate(pdfname, pagesize=landscape(A4), rightMargin=1.9 * cm, leftMargin=1.9 * cm, topMargin=1 * cm, bottomMargin=1 * cm)
        doc.build(Story)

        with open(pdfname, 'rb') as pdf:
            response = HttpResponse(pdf.read(), content_type='application/pdf')
            response['Content-Disposition'] = 'attachment; filename=%s' % (reportData.graph_name.split('.')[0] + '.pdf')

            return response
    else:
        return HttpResponseRedirect('/login/')

def report_new(request):
    if request.user.is_authenticated():
        return render(request, 'report_new.html', {'username': request.session['username']})
    else:
        return HttpResponseRedirect('/login/')

def report_graph(prevdate, nextdate, report_title):
    titles = ['ID', 'Wdate', 'EMPnum', 'EMPname', 'center_team', 'position', 'reasontype', 'lognum', 'logtable', 'IP',
              'MAC', 'outflow_File', 'url_Link', 'model', 'owner', 'source', 'application', 'receiver',
              'rf_outflow_File', 'rf_outflow_File_detail', 'upfilename', 'violation', 'severity']
    data = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반')
    DF = pandas.DataFrame(list(data.values()), index=None, columns=titles)

    font_location = "C:\Windows\Fonts\malgunbd.ttf"
    font_name = font_manager.FontProperties(fname=font_location).get_name()
    rc('font', family=font_name)

    PT = pandas.pivot_table(DF, index="center_team", columns="reasontype", values="violation", aggfunc="count")
    PT.plot(kind='Bar')
    plt.ylabel("Count")
    plt.xticks(rotation=0)

    fig = plt.gcf()
    fig.savefig(os.getcwd() + "\\SOA\\static\\graph\\" + report_title + ".png")

@csrf_exempt
def report_process(request):
    if request.user.is_authenticated():
        t = ['월', '화', '수', '목', '금', '토', '일']
        teamlist = []
        topTeam = []
        vioRank = []
        mainvio_dict = {}
        web_outfile = ''
        usb_outfile = ''
        app_outfile = ''
        graph_path = ''

        rMonth = request.POST.get('rMonth')
        rWeek = request.POST.get('rWeek')
        report_title = '%s월 %s주차 주간보고서'%(rMonth, rWeek)

        prevdate = datetime(int(request.POST.get('pdate').split('/')[0]), int(request.POST.get('pdate').split('/')[1]), int(request.POST.get('pdate').split('/')[2]))
        nextdate = datetime(int(request.POST.get('ndate').split('/')[0]), int(request.POST.get('ndate').split('/')[1]), int(request.POST.get('ndate').split('/')[2]))

        reason_miss = UactivReportSend.objects.count()
        reason_totalCnt = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date()).count() + reason_miss
        vioCnt = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반').count()
        bisCnt = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='업무').count()
        replyCnt = vioCnt + bisCnt

        vioType = {'USB' : UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', reasontype='USB').count(),
                   'APP' : UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', reasontype='APP').count(),
                   'WEB' : UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', reasontype='WEB').count()}
        vioType = sorted(vioType.items(), key=itemgetter(1), reverse=True)
        for i in range(0, len(vioType[0])+1):
            vioRank.append('%s (%s)' % (vioType[i][0], vioType[i][1]))

        highSeverityCnt = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', severity='상').count()
        middleSeverityCnt = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', severity='중').count()
        lowSeverityCnt = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', severity='하').count()

        vioReasons = UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반')

        for item in vioReasons:
            teamlist.append(item.center_team)
            print(mainvio_dict)
            if ('%s-%s-%s' % (item.center_team, item.empname, item.position) in mainvio_dict):
                if (item.severity == '상'):
                    mainvio_dict['%s-%s-%s' % (item.center_team, item.empname, item.position)]['상'] += 1
                elif (item.severity == '중'):
                    mainvio_dict['%s-%s-%s' % (item.center_team, item.empname, item.position)]['중'] += 1
                elif (item.severity == '하'):
                    mainvio_dict['%s-%s-%s' % (item.center_team, item.empname, item.position)]['하'] += 1
            else:
                mainvio_dict['%s-%s-%s' % (item.center_team, item.empname, item.position)] = {'상': 0, '중': 0, '하': 0}

                if (item.severity == '상'):
                    mainvio_dict['%s-%s-%s' % (item.center_team, item.empname, item.position)]['상'] += 1
                elif (item.severity == '중'):
                    mainvio_dict['%s-%s-%s' % (item.center_team, item.empname, item.position)]['중'] += 1
                elif (item.severity == '하'):
                    mainvio_dict['%s-%s-%s' % (item.center_team, item.empname, item.position)]['하'] += 1

        # Top 5
        teamlist = Counter(teamlist).most_common()
        for i in range(0, len(teamlist)):
            topTeam.append(teamlist[i][0])

        # main violation
        temp = list(mainvio_dict.items())[0]
        if (len(mainvio_dict) != 0):
            for i in range(1, len(mainvio_dict)):
                if (temp[1].get('상') < list(mainvio_dict.items())[i][1].get('상')):
                    temp = list(mainvio_dict.items())[i]
                elif (temp[1].get('상') > list(mainvio_dict.items())[i][1].get('상')):
                    continue

                if (temp[1].get('중') < list(mainvio_dict.items())[i][1].get('중')):
                    temp = list(mainvio_dict.items())[i]
                elif (temp[1].get('중') > list(mainvio_dict.items())[i][1].get('중')):
                    continue

                if (temp[1].get('하') < list(mainvio_dict.items())[i][1].get('하')):
                    temp = list(mainvio_dict.items())[i]
                elif (temp[1].get('하') > list(mainvio_dict.items())[i][1].get('하')):
                    continue

        mainvioinfo = {'team':temp[0].split('-')[0], 'name':temp[0].split('-')[1], 'position':temp[0].split('-')[2]}

        if (temp[1].get('상') >= 1):
            for item in UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', severity='상'):
                outreason = item.rf_outflow_file
                break
        elif (temp[1].get('중') >= 1):
            for item in UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', severity='중'):
                outreason = item.rf_outflow_file
                break
        else:
            for item in UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', severity='하'):
                outreason = item.rf_outflow_file
                break

        for item in UactivReportSaves.objects.filter(wdate__gte=prevdate.date(), wdate__lte=nextdate.date(), violation='위반', empname=temp[0].split('-')[1]):
            if (item.reasontype == 'WEB' and item.severity == '상'):
                web_outfile = item.outflow_file
            elif (item.reasontype == 'WEB' and item.severity == '중'):
                web_outfile = item.outflow_file
            elif (item.reasontype == 'WEB' and item.severity == '하'):
                web_outfile = item.outflow_file

            if (item.reasontype == 'USB' and item.severity == '상'):
                usb_outfile = item.outflow_file
            elif (item.reasontype == 'USB' and item.severity == '중'):
                usb_outfile = item.outflow_file
            elif (item.reasontype == 'USB' and item.severity == '하'):
                usb_outfile = item.outflow_file

            if (item.reasontype == 'APP' and item.severity == '상'):
                app_outfile = item.outflow_file
            elif (item.reasontype == 'APP' and item.severity == '중'):
                app_outfile = item.outflow_file
            elif (item.reasontype == 'APP' and item.severity == '하'):
                app_outfile = item.outflow_file

        mainvioTotalCnt = UactivReportSaves.objects.filter(center_team=mainvioinfo['team'], empname=mainvioinfo['name'],position=mainvioinfo['position'] ,violation='위반').count()

        # create graph
        report_graph(prevdate, nextdate, report_title)

        return render(request, 'report_write.html', {'username': request.session['username'], 'rMonth': request.POST.get('rMonth'), 'rWeek': request.POST.get('rWeek'), 'prevdate': prevdate, 'pDow': t[prevdate.weekday()],
                                                     'nextdate': nextdate, 'nDow': t[nextdate.weekday()], 'reason_totalCnt': reason_totalCnt, 'vioCnt': vioCnt, 'bisCnt': bisCnt, 'replyCnt': replyCnt, 'highSeverityCnt': highSeverityCnt,
                                                     'middleSeverityCnt': middleSeverityCnt, 'lowSeverityCnt': lowSeverityCnt, 'topTeam': topTeam, 'violator':mainvioinfo, 'violatorCnt': len(mainvio_dict), 'outreason': outreason,
                                                     'mainvioTotalCnt': mainvioTotalCnt, 'vioRank': vioRank, 'web_outfile': web_outfile, 'usb_outfile': usb_outfile, 'app_outfile': app_outfile, 'graph_name': report_title+'.png'})
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def report_complete(request):
    if request.user.is_authenticated():
        dt = datetime.now()

        new = WeekReportSaves(title=request.POST.get('title'), summary=request.POST.get('summary'), wdatetime=str(dt).split('.')[0], type_rank=request.POST.get('typeRank'), severity_cnt=request.POST.get('severity-Cnt'), top5=request.POST.get('top5'), violator=request.POST.get('violator'), web_file=request.POST.get('web-file'), usb_file=request.POST.get('usb-file'), app_file=request.POST.get('app-file'), outreason=request.POST.get('outreason'), accumulate_cnt=request.POST.get('accumulateCnt'), measure=request.POST.get('measure'), graph_name=request.POST.get('graph_name'))
        new.save()

        return render(request, 'report_complete.html', {'username': request.session['username']})
    else:
        return HttpResponseRedirect('/login/')

# Guideline tab
def statute_pact(request):
    if request.user.is_authenticated():
        statuteData = SbtProtectionAct.objects.all()

        return render(request, 'statute_pact.html', {'username': request.session['username'], 'statuteData': statuteData})
    else:
        return HttpResponseRedirect('/login/')

def statute_ww(request):
    if request.user.is_authenticated():
        statuteData = SbtWwCooperation.objects.all()

        return render(request, 'statute_ww.html', {'username': request.session['username'], 'statuteData': statuteData})
    else:
        return HttpResponseRedirect('/login/')

def statute_itp(request):
    if request.user.is_authenticated():
        statuteData = SbtItpAct.objects.all()

        return render(request, 'statute_itp.html', {'username': request.session['username'], 'statuteData': statuteData})
    else:
        return HttpResponseRedirect('/login/')

def statute_puc(request):
    if request.user.is_authenticated():
        statuteData = SbtPreventUc.objects.all()

        return render(request, 'statute_puc.html', {'username': request.session['username'], 'statuteData': statuteData})
    else:
        return HttpResponseRedirect('/login/')

def case(request, year):
    if request.user.is_authenticated():
        if year == '2013':
            return render(request, 'case_2013.html', {'username': request.session['username']})
        elif year == '2012':
            return render(request, 'case_2012.html', {'username': request.session['username']})
        elif year == '2011':
            return render(request, 'case_2011.html', {'username': request.session['username']})
        elif year == '2010':
            return render(request, 'case_2010.html', {'username': request.session['username']})
        elif year == '2009':
            return render(request, 'case_2009.html', {'username': request.session['username']})
        elif year == '2008':
            return render(request, 'case_2008.html', {'username': request.session['username']})
        elif year == '2007':
            return render(request, 'case_2007.html', {'username': request.session['username']})
        elif year == '2006':
            return render(request, 'case_2006.html', {'username': request.session['username']})
        elif year == '2005':
            return render(request, 'case_2005.html', {'username': request.session['username']})
        elif year == '2004':
            return render(request, 'case_2004.html', {'username': request.session['username']})
        elif year == '2003':
            return render(request, 'case_2003.html', {'username': request.session['username']})
    else:
        return HttpResponseRedirect('/login/')

def preventive_spy(request):
    if request.user.is_authenticated():
        return render(request, 'preventive_spy.html', {'username': request.session['username']})
    else:
        return HttpResponseRedirect('/login/')

def preventive_task(request):
    if request.user.is_authenticated():
        return render(request, 'preventive_task.html', {'username': request.session['username']})
    else:
        return HttpResponseRedirect('/login/')

def preventive_overseas(request):
    if request.user.is_authenticated():
        return render(request, 'preventive_overseas.html', {'username': request.session['username']})
    else:
        return HttpResponseRedirect('/login/')

def communication(request):
    if request.user.is_authenticated():
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

        totalCnt = ConNet.objects.all().count()
        dataList = ConNet.objects.all()[start_pos:end_pos]

        totalPageList, prev, next = paging(totalCnt, currentPage)

        return render_to_response('communication.html', {'username': request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

# Employee tab
@csrf_exempt
def employee(request):
    if request.user.is_authenticated():
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
            totalCnt = Hrdb.objects.filter(Q(empnum=search_data) | Q(disksn=search_data) | Q(empname=search_data) | Q(cname=search_data) | Q(ip=search_data) | Q(mac=search_data) | Q(center=search_data) | Q(teamnum=search_data) | Q(team=search_data) | Q(position=search_data) | Q(age=search_data) | Q(email=search_data) | Q(datehired=search_data)).count()
            dataList = Hrdb.objects.filter(Q(empnum=search_data) | Q(disksn=search_data) | Q(empname=search_data) | Q(cname=search_data) | Q(ip=search_data) | Q(mac=search_data) | Q(center=search_data) | Q(teamnum=search_data) | Q(team=search_data) | Q(position=search_data) | Q(age=search_data) | Q(email=search_data) | Q(datehired=search_data))[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('employee.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next, 'search_data': search_data}, RequestContext(request))

        else:
            totalCnt = Hrdb.objects.all().count()
            dataList = Hrdb.objects.all()[start_pos:end_pos]

            totalPageList, prev, next = paging(totalCnt, currentPage)

            return render_to_response('employee.html', {'username':request.session['username'], 'dataList': dataList, 'currentPage': currentPage, 'totalPageList': totalPageList, 'prev': prev, 'next': next}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

# Setting tab
def recaptcha(request, postdata):
    rc_challenge = postdata.get('recaptcha_challenge_field','')
    rc_user_input = postdata.get('recaptcha_response_field','')
    url = 'http://www.google.com/recaptcha/api/verify'
    values = {'privatekey':settings.RECAPTCHA_PRIVATE_KEY,
              'remoteip':request.META['REMOTE_ADDR'],
              'challenge':rc_challenge,
              'response':rc_user_input,}
    data = urllib.parse.urlencode(values).encode('utf-8')
    req = urllib.request.Request(url, data)
    response = urllib.request.urlopen(req)
    answer = response.read().split()[0]
    response.close()

    return answer

@csrf_exempt
def account(request):
    if request.user.is_authenticated():
        if request.method == 'POST':
            user = authenticate(username=request.session['username'], password=request.POST.get('account_pw'))
            if user is not None:
                if user.is_active:
                    dataList = AuthUser.objects.all()
                    return render_to_response('account_select.html', {'username': request.session['username'], 'dataList': dataList})
                else:
                    return HttpResponse('Disabled account')
            else:
                return render_to_response('account_login.html', {'username': request.session['username'], 'message': 'no Password'})
        else:
            return render_to_response('account_login.html', {'username':request.session['username']})
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def account_add(request):
    if request.user.is_authenticated():
        if request.method == 'POST':
            edit_form = EditForm(request.POST)

            postdata = request.POST.copy()
            captcha = recaptcha(request, postdata)
            if captcha.decode('utf-8') == 'true':
                usr = User.objects.create_superuser(request.POST.get('userid'), request.POST.get('email'), request.POST.get('password'))
                usr.first_name = request.POST.get('first_name')
                usr.last_name = request.POST.get('last_name')
                usr.save()

                return HttpResponseRedirect('/home/', {'username': request.session['username'], 'message': '계정 추가가 완료되었습니다.'})
            else:
                captcha_response = 'CAPTCHA 문자가 일치하지 않습니다.'

                return render_to_response('account_add.html', {'username': request.session['username'], 'edit_fprm': edit_form, 'captcha_response': captcha_response})
        else:
            edit_form = EditForm()

            return render_to_response('account_add.html', {'username': request.session['username'], 'edit_fprm': edit_form})
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def account_del(request):
    if request.user.is_authenticated():
        if request.method == 'POST':
            print(request.POST.get('delid'))
            User.objects.get(username = request.POST.get('delid')).delete()

            return HttpResponseRedirect('/home/', {'username': request.session['username'], 'message': '계정 제거가 완료되었습니다.'})
        else:
            selectData = User.objects.all()

            return render_to_response('account_del.html', {'username': request.session['username'], 'selectData': selectData})
    else:
        return HttpResponseRedirect('/login/')

@csrf_exempt
def account_change(request):
    if request.user.is_authenticated():
        if request.method == 'POST':
            edit_form = EditForm(request.POST)

            postdata = request.POST.copy()
            captcha = recaptcha(request, postdata)

            if captcha.decode('utf-8') == 'true':
                usr = User.objects.get(username=request.session['username'])
                usr.set_password(request.POST.get('chpw'))
                usr.save()

                return render_to_response('login.html', {'message': '비밀번호가 변경되었습니다. 다시 로그인하십시오.'})
            else:
                captcha_response = 'CAPTCHA 문자가 일치하지 않습니다.'

                return render_to_response('account_change.html', {'username': request.session['username'], 'edit_form': edit_form, 'captcha_response': captcha_response})

        else:
            edit_form = EditForm()

            return render_to_response('account_change.html', {'username': request.session['username'], 'edit_form': edit_form})
    else:
        return HttpResponseRedirect('/login/')

def solution(request):
    if request.user.is_authenticated():
        return render_to_response('checking.html', {'username': request.session['username']}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

# Support tab
def support(request):
    if request.user.is_authenticated():
        return render_to_response('support.html', {'username': request.session['username']}, RequestContext(request))
    else:
        return HttpResponseRedirect('/login/')

# Employees reason
def e_login(request):
    form = ELoginForm()
    if request.method == 'POST':
        form = ELoginForm(request.POST)
        if form.is_valid():
            cd = form.cleaned_data
            if UactivReportSend.objects.filter(empnum=int(cd['empnum']), lognum=int(cd['lognum'])):
                hr = Hrdb.objects.get(empnum=int(cd['empnum']))
                user = UactivReportSend.objects.get(empnum=int(cd['empnum']), lognum=int(cd['lognum']))

                request.session['empname'] = hr.empname
                request.session['empnum'] = cd['empnum']
                request.session['lognum'] = cd['lognum']
                request.session['logtable'] = user.logtable
                request.session['reasontype'] = user.reasontype

                if hr.secretkey is None:
                    return HttpResponseRedirect('/employee_login/new/')
                else:
                    return HttpResponseRedirect('/employee_login/qr_auth/')
            else:
                return render(request, 'e_login.html', {'message': 'Login Fail!'})
        else:
            form = ELoginForm()
    return render(request, 'e_login.html', {})

@csrf_exempt
def e_new(request):
    if request.method == 'POST':
        secretKey = request.POST.get('sck')
        uotp = request.POST.get('otp')

        if pyotp.TOTP(secretKey).now() == uotp:
            if request.session['reasontype'] == 'USB':
                return redirect('usb')
            elif request.session['reasontype'] == 'WEB':
                return redirect('web')
            elif request.session['reasontype'] == 'APP':
                return HttpResponseRedirect('/application/')

        else:
            totp = pyotp.TOTP(secretKey).provisioning_uri('SOA Auth (' + request.session['empname'] + ')')

            return render_to_response('e_new.html', {'totp': totp, 'secretKey': secretKey, 'message': '다시 확인해주세요.'})

    secretKey = pyotp.random_base32()

    hr = Hrdb.objects.get(empnum=request.session['empnum'])
    hr.secretkey = secretKey
    hr.save()

    totp = pyotp.TOTP(secretKey).provisioning_uri('SOA Auth (' + request.session['empname'] + ')')

    return render_to_response('e_new.html', {'totp': totp, 'secretKey': secretKey})

@csrf_exempt
def e_qr(request):
    if request.method == 'POST':
        secretKey = request.POST.get('sck')
        uotp = request.POST.get('otp')

        if pyotp.TOTP(secretKey).now() == uotp:
            if request.session['reasontype'] == 'USB':
                return redirect('usb')
            elif request.session['reasontype'] == 'WEB':
                return redirect('web')
            elif request.session['reasontype'] == 'APP':
                return redirect('/application/')
            
        else:
            totp = pyotp.TOTP(secretKey).provisioning_uri('SOA Auth (' + request.session['empname'] + ')')

            return render_to_response('qr_auth.html', {'totp': totp, 'secretKey': secretKey, 'message': '다시 확인해주세요.'})

    secretKey = Hrdb.objects.get(empnum = request.session['empnum']).secretkey

    return render_to_response('qr_auth.html', {'secretKey': secretKey})

@csrf_exempt
def e_usb(request):
    if request.user.is_authenticated():
        return render(request, 'e_usb.html', {})
    else:
        return HttpResponseRedirect('/employee_login/')

@csrf_exempt
def e_web(request):
    if request.user.is_authenticated():
        site = []

        dt = datetime.now()
        dt.isoformat()
        nowdate = str(dt).split(' ')[0]

        employee = Hrdb.objects.get(e_num=request.session['e_num'])
        log_id = request.session['log_num']
        if request.session['reason_num'] == '2':
            site = HistChrome.objects.get(id=int(log_id))

        return render_to_response('e_web.html', {'nowdate': nowdate, 'employee':employee, 'site':site}, RequestContext(request))
    else:
        return HttpResponseRedirect('/employee_login/')

@csrf_exempt
def e_application(request):
    dt = datetime.now()
    dt.isoformat()
    nowdate = str(dt).split(' ')[0]

    employee = Hrdb.objects.get(empnum=request.session['empnum'])
    log_id = request.session['lognum']
    logData = Oafile.objects.get(id=int(log_id))

    return render(request, 'e_application.html', {'nowdate':nowdate, 'employee':employee, 'logData':logData}, RequestContext(request))


@csrf_exempt
def e_success(request):
    dt = datetime.now()
    dt.isoformat()
    nowdate = str(dt).split(' ')[0]

    if request.method == 'POST':
        if request.FILES:
            files = request.FILES['file']
            if request.POST.get('site'):
                new = UactivReportSaves(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('empname'), empnum=int(request.POST.get('empnum')), position=request.POST.get('position'), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), url_link=request.POST.get('site'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), upfilename=files, lognum=int(request.session['lognum']), logtable=request.session['logtable'], reasontype=request.session['reasontype'])
            elif request.POST.get('model'):
                new = UactivReportSaves(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('empname'), empnum=int(request.POST.get('empnum')), position=request.POST.get('position'), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), model=request.POST.get('model'), owner=request.POST.get('owner'), source=request.POST.get('source'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), upfilename=files, lognum=int(request.session['lognum']), logtable=request.session['logtable'], reasontype=request.session['reasontype'])
            elif request.POST.get('application'):
                new = UactivReportSaves(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('empname'), empnum=int(request.POST.get('empnum')), position=request.POST.get('position'), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), application=request.POST.get('application'), receiver=request.POST.get('receiver'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), upfilename=files, lognum=int(request.session['lognum']), logtable=request.session['logtable'], reasontype=request.session['reasontype'])

            new.save()

            delReasonMember = UactivReportSend.objects.get(empnum=int(request.POST.get('empnum')), lognum=request.session['lognum'])
            delReasonMember.delete()
        else:
            if request.POST.get('site'):
                new = UactivReportSaves(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('empname'), empnum=int(request.POST.get('empnum')), position=request.POST.get('position'), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), url_link=request.POST.get('site'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), lognum=int(request.session['lognum']), logtable=request.session['logtable'], reasontype=request.session['reasontype'])
            elif request.POST.get('model'):
                new = UactivReportSaves(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('empname'), empnum=int(request.POST.get('empnum')), position=request.POST.get('position'), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), model=request.POST.get('model'), owner=request.POST.get('owner'), source=request.POST.get('source'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), lognum=int(request.session['lognum']), logtable=request.session['logtable'], reasontype=request.session['reasontype'])
            elif request.POST.get('application'):
                new = UactivReportSaves(wdate=nowdate, center_team=request.POST.get('belong'), empname=request.POST.get('empname'), empnum=int(request.POST.get('empnum')), position=request.POST.get('position'), ip=request.POST.get('ip'), mac=request.POST.get('mac'), outflow_file=request.POST.get('outflow_file'), application=request.POST.get('application'), receiver=request.POST.get('receiver'), rf_outflow_file=request.POST.get('reason'), rf_outflow_file_detail=request.POST.get('detail'), lognum=int(request.session['lognum']), logtable=request.session['logtable'], reasontype=request.session['reasontype'])

            new.save()

            delReasonMember = UactivReportSend.objects.get(empnum=int(request.POST.get('empnum')), lognum=request.session['lognum'])
            delReasonMember.delete()

    return render(request, 'e_success.html', {})

def test(request):
    dataList = ['a','b']
    return render(request, 'clip.html', {'username':request.session['username'], 'dataList':dataList})

@csrf_exempt
def test3(request):
    if request.method == 'POST':
        edit_form = EditForm(request.POST)

        postdata = request.POST.copy()
        captcha = recaptcha(request, postdata)
        if captcha.decode('utf-8') == 'true':
            captcha_response = 'YOU ARE HUMAN'
        else:
            captcha_response = 'YOU MUST BE A ROBOT'

        return render_to_response('test_captcha.html', {'edit_form': edit_form, 'captcha_response': captcha_response})
    else:
        edit_form = EditForm()

        return render_to_response('test_captcha.html', {'edit_form': edit_form})