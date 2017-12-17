from django import template
from SOA.models import *

register = template.Library()

@register.filter(name='get_total_outflow')
def get_total_outflow(empnum):
    totalCnt = UactivReportSaves.objects.filter(empnum=empnum, violation='위반').count()

    return totalCnt

@register.filter(name='get_color')
def get_color(id):
    Data = UactivReportSaves.objects.get(id=id)

    if Data.violation == '업무':
        return '#0054FF'
    elif Data.violation == '위반':
        if Data.severity == '상':
            return '#FF0000'
        elif Data.severity == '중':
            return '#FFBB00'
        elif Data.severity == '하':
            return '#1DDB16'