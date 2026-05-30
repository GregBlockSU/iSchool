#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 30 07:12:16 2018

@author: emeliabarron
"""

#from urllib import request
import urllib.request

url = 'https://www.nytimes.com/2018/10/30/science/black-hole-milky-way.html?rref=collection%2Fsectioncollection%2Fscience&action=click&contentCollection=science&region=rank&module=package&version=highlights&contentPlacement=1&pgtype=sectionfront'
with urllib.request.urlopen(url) as response:
    html = response.read()

print(html)
#bbcurl = "https://www.bbc.com/news/science-environment-46028862"
#html = request.urlopen(twitterurl).read().decode('utf8')
#response = request.url(bbcurl)

print(type(response))
# return is <class 'http.client.HTTPResponse'>

#html = response.read().decode('utf8')
#%%
print(type(html))
print(html[:500])
print(html)
#%%
from bs4 import BeautifulSoup
htmlsoup=BeautifulSoup(html, 'html.parser')
#%%
print(type(htmlsoup))
print(htmlsoup)
firsttitle=htmlsoup.title
print(firsttitle)

