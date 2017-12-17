from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^login/', views.user_login, name='login'),
    url(r'^logout/', views.user_logout, name='logout'),

    url(r'^home/(?P<dash_id>\w+)/', views.home, name='home'),

    url(r'^logs/beginning/file_log/', views.b_file_log, name='b_file_log'),
    url(r'^logs/beginning/driver/', views.b_driver, name='b_driver'),
    url(r'^logs/beginning/download_chrome/', views.b_download_chrome, name='b_download_chrome'),
    url(r'^logs/beginning/history_chrome/', views.b_history_chrome, name='b_history_chrome'),
    url(r'^logs/beginning/history_ie/', views.b_history_ie, name='b_history_ie'),
    url(r'^logs/beginning/log_on_off/', views.b_log_on_off, name='b_log_on_off'),
    url(r'^logs/beginning/oa_file/', views.b_oa_file, name='b_oa_file'),
    url(r'^logs/beginning/oa_mtp/', views.b_oa_mtp, name='b_oa_mtp'),
    url(r'^logs/beginning/partition_win10/', views.b_partition_win10, name='b_partition_win10'),
    url(r'^logs/beginning/quick_scan/', views.b_quick_scan, name='b_quick_scan'),
    url(r'^logs/beginning/registry/', views.b_registry, name='b_registry'),
    url(r'^logs/beginning/zip_scan/', views.b_zip_scan, name='b_zip_scan'),
    url(r'^logs/beginning/r_file/', views.b_rfile, name='b_rfile'),
    url(r'^logs/beginning/mft/', views.b_mft, name='b_mft'),
    url(r'^logs/beginning/usnjrnl/', views.b_usnjrnl, name='b_usnjrnl'),
    url(r'^logs/beginning/archive/', views.b_archive, name='b_archive'),

    url(r'^logs/outflowsign/', views.outflowsign, name='logs_outflowsign'),
    url(r'^logs/outflowaction/', views.outflowaction, name='logs_outflowaction'),
    url(r'^logs/leavesign/', views.leavesign, name='logs_leavesign'),

    url(r'^reason/waiting/', views.waiting, name='reason_waiting'),
    url(r'^reason/process/$', views.process, name='reason_process'),
    url(r'^reason/process/(?P<reason_id>\w+)/', views.reason_check, name='reason_check'),
    url(r'^reason/complete/$', views.complete, name='reason_complete'),
    url(r'^reason/complete/(?P<reason_id>\w+)/', views.reason_view, name='reason_view'),

    url(r'^report/$', views.report, name='report'),
    url(r'^report/(?P<report_id>\d+)/$', views.report_view, name='report_view'),
    url(r'^report/down/(?P<report_id>\d+)/$', views.report_down, name='report_down'),
    url(r'^report/new/$', views.report_new, name='report_new'),
    url(r'^report/write/$', views.report_process, name='report_write'),
    url(r'^report/complete/$', views.report_complete, name='report_complete'),

    url(r'^guideline/statute/pact/', views.statute_pact, name='guideline_statute_pact'),
    url(r'^guideline/statute/ww/', views.statute_ww, name='guideline_statute_ww'),
    url(r'^guideline/statute/itp/', views.statute_itp, name='guideline_statute_itp'),
    url(r'^guideline/statute/puc/', views.statute_puc, name='guideline_statute_puc'),

    url(r'^guideline/case/(?P<year>\d{4})/$', views.case, name='guideline_case'),
    url(r'^guideline/preventive/spy', views.preventive_spy, name='guideline_preventive_spy'),
    url(r'^guideline/preventive/task', views.preventive_task, name='guideline_preventive_task'),
    url(r'^guideline/preventive/overseas', views.preventive_overseas, name='guideline_preventive_overseas'),
    url(r'^guideline/communication/', views.communication, name='guideline_communication'),

    url(r'^setting/account/$', views.account, name='setting_account'),
    url(r'^setting/account/add/$', views.account_add, name='setting_account_add'),
    url(r'^setting/account/delete/$', views.account_del, name='setting_account_del'),
    url(r'^setting/account/change/$', views.account_change, name='setting_account_change'),

    url(r'^setting/solution/', views.solution, name='setting_solution'),

    url(r'^employee/', views.employee, name='employee'),
    url(r'^support', views.support, name='support'),

    url(r'^employee_login/$', views.e_login, name='employee_login'),
    url(r'^employee_login/new/$', views.e_new, name='e_new'),
    url(r'^employee_login/qr_auth/$', views.e_qr, name='qr_auth'),

    url(r'^usb/', views.e_usb, name='usb'),
    url(r'^web/', views.e_web, name='web'),
    url(r'^application/', views.e_application, name='application'),
    url(r'^success/', views.e_success, name='success'),

    url(r'^test/', views.test3, name='test'),
]
