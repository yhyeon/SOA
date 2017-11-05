from django import forms

class LoginForm(forms.Form):
    username = forms.CharField(label='usename')
    password = forms.CharField(widget=forms.PasswordInput, label='password')

class ELoginForm(forms.Form):
    empnum = forms.CharField(label='empnum')
    lognum = forms.CharField(label='lognum')
