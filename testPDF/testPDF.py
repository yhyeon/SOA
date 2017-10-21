#-*-coding:utf-8

from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.units import cm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Flowable
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.graphics.shapes import Image, Drawing

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


# Font Settings
pdfmetrics.registerFont(TTFont("malgun", "malgun.ttf"))
pdfmetrics.registerFont(TTFont("malgunbd", "malgunbd.ttf"))

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name="Malgun", fontName="malgun"))
styles.add(ParagraphStyle(name="MalgunB", fontName="malgunbd"))

# Create Content
Story = []
img = 'test1.png'
d = Drawing(0,0)
i = Image(370,-410,12.5*cm,7.4*cm,img)
d.add(i)
Story.append(d)

ptext = u'<font size=24>[업무 파일 반출] %s월 %s주차 주간 보고서</font>' % ('10', '3')
Story.append(Paragraph(ptext, styles["MalgunB"]))
Story.append(Spacer(1,34))

line = MKLine(700)
Story.append(line)
Story.append(Spacer(1,12))

ptext = u'<font size=16>- %s/%s(%s) ~ %s/%s(%s) 총 %s개 사유서 발송 중 %s개 회신 (위반 %s개, 업무 %s개)</font>' % ('10', '16', '월', '10', '22', '일', '10', '9', '2', '7')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,24))

ptext = u'<font size=14>[특이사항]</font>'
Story.append(Paragraph(ptext, styles["MalgunB"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>ㆍ유형별 반출 통계 : %s (%s) > %s (%s) > %s (%s)</font>' % ('USB', '5', 'APP', '3', 'WEB', '2')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>ㆍ반출 심각도 통계 : [上] %s , [中] %s , [下] %s</font>' % ('5', '3', '2')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>ㆍ보안 위반자 소속 TOP 5 : %s, %s, %s, %s, %s</font>' % ('사원1', '사원2', '사원3', '사원4', '사원5')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,24))

ptext = u'<font size=14>[주요 위반자]</font>'
Story.append(Paragraph(ptext, styles["MalgunB"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>ㆍ%s본부 %s팀 %s %s 포함 %s명</font>' % ('서울', '마케팅', '김가영', '대리', '3')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>- WEB 반출 파일 : %s , %s</font>' % ('파일1', '파일2')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>- USB 반출 파일 : %s , %s</font>' % ('파일1', '파일2')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>- APP 반출 파일 : %s , %s</font>' % ('파일1', '파일2')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>- 반출 사유 : %s</font>' % ('반출 사유...')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>- 총 누적 위반 횟수 : %s</font>' % ('2')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,24))

ptext = u'<font size=14>[조치사항]</font>'
Story.append(Paragraph(ptext, styles["MalgunB"]))
Story.append(Spacer(1,12))

ptext = u'<font size=12>ㆍ%s</font>' % ('이렇게 저렇게 조치했다.')
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,40))

line = MKLine(700)
Story.append(line)
Story.append(Spacer(1,12))

ptext = u'<font size=16>경영지원본부 보안팀</font>'
Story.append(Paragraph(ptext, styles["Malgun"]))
Story.append(Spacer(1,12))

doc = SimpleDocTemplate("test.pdf", pagesize=landscape(A4), rightMargin=1.9*cm, leftMargin=1.9*cm, topMargin=1*cm, bottomMargin=1*cm)
doc.build(Story)
