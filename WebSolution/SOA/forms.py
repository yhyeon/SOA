from django import forms

class LoginForm(forms.Form):
    username = forms.CharField(label='usename')
    password = forms.CharField(widget=forms.PasswordInput, label='password')

class ELoginForm(forms.Form):
    e_num = forms.CharField(label='e_num')
    log_num = forms.CharField(label='e_num')
