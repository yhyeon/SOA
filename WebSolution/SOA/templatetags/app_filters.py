from django import template
from SOA.models import *

register = template.Library()

@register.filter(name='get_total_outflow')
def get_total_outflow(empnum):
    totalCnt = UactivReportSaves.objects.filter(empnum=empnum, violation='위반').count()

    return totalCnt