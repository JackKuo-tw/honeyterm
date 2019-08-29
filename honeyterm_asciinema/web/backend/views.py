from django.shortcuts import render
from .models import *
from django.http import HttpResponse
import os

FILENAME_PREFIX = "honeypot-"


def index(request):
    """Home page"""
    dirs = os.listdir('/tmp/honeypot')
    print(dirs)
    ip_country = list()
    for name in dirs:
        if FILENAME_PREFIX not in name:
            continue
        ip = name[len(FILENAME_PREFIX):]
        info = ip_info(ip)
        ip_country.append({
            "IP": ip,
            "country": info['country'],
            "hostname": info['hostname']
        })
    print(ip_country)
    return render(request, 'index.html', locals())


def detail(request, ip):
    path = '/tmp/honeypot/' + FILENAME_PREFIX + ip
    files = os.listdir(path)
    if 'login' in files:
        with open(path + '/login') as f:
            login = f.read().split("\n")

    conn_info = ip_info(ip)

    return render(request, 'detail.html', locals())


def ip_info(addr=''):
    from urllib.request import urlopen
    from json import load
    if addr == '':
        url = 'https://ipinfo.io/json'
    else:
        url = 'https://ipinfo.io/' + addr + '/json'
    res = urlopen(url)
    data = load(res)
    if 'bogon' in data:
        return {"country": "Bogon", "hostname": "Bogon"}
    else:
        return data
