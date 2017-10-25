from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^login/', views.user_login, name='login'),
    url(r'logout/', views.user_logout, name='logout'),
    url(r'^home/', views.home, name='home'),

    url(r'^logs/beginning/', views.beginning, name='logs_beginning'),
    url(r'^logs/outflowsign/', views.outflowsign, name='logs_outflowsign'),
    url(r'^logs/outflowaction/', views.outflowaction, name='logs_outflowaction'),
    url(r'^logs/leavesign/', views.leavesign, name='logs_leavesign'),

    url(r'^reason/waiting/', views.waiting, name='reason_waiting'),
    url(r'^reason/process/$', views.process, name='reason_process'),
    url(r'^reason/process/(?P<reason_id>\w+)/', views.reason_check, name='reason_check'),
    url(r'^reason/complete/$', views.complete, name='reason_complete'),
    url(r'^reason/complete/(?P<reason_id>\w+)/', views.reason_view, name='reason_view'),
    url(r'^report/$', views.report, name='report'),
    url(r'^report/pop/', views.report_pop, name='report_pop'),
    url(r'^report/new/', views.report_new, name='report_new'),
    url(r'^report/write/', views.report_process, name='report_write'),
    url(r'^guideline/statute/', views.statute, name='guideline_statute'),
    url(r'^guideline/case/', views.case, name='guideline_case'),
    url(r'^guideline/preventive/', views.preventive, name='guideline_preventive'),
    url(r'^guideline/communication/', views.communication, name='guideline_communication'),
    url(r'^setting/account/', views.account, name='setting_account'),
    url(r'^setting/solution/', views.solution, name='setting_solution'),
    url(r'^employee/', views.employee, name='employee'),
    url(r'^support', views.support, name='support'),
    url(r'^employee_login/', views.e_login, name='employee_login'),
    url(r'^usb/', views.e_usb, name='usb'),
    url(r'^web/', views.e_web, name='web'),
    url(r'^application/', views.e_application, name='application'),
    url(r'^success/', views.e_success, name='success'),

]