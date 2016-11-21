# from __future__ import absolute_import
# from __future__ import division, print_function, unicode_literals

# #from sumy.parsers.html import HtmlParser
# #from sumy.parsers.plaintext import PlaintextParser
# #from sumy.nlp.tokenizers import Tokenizer
# #from sumy.summarizers.lsa import LsaSummarizer as Summarizer
# #from sumy.nlp.stemmers import Stemmer
# #from sumy.utils import get_stop_words
# #from openpyxl import load_workbook
# from bs4 import BeautifulSoup
# import urllib
# import urllib2

# #mport requests
# import re
# import json as m_json


class getContent():
    pass


#     def get_videos(self, input):
#         print ("get_videos() entered")
#         list_videos = {}
#         query = urllib.quote(input)
#         url = "https://www.youtube.com/results?search_query=" + query
#         response = urllib2.urlopen(url)
#         html = response.read()
#         soup = BeautifulSoup(html)
#         i = 0
#         print ("about to iterate through videos found")
#         for vid in soup.findAll(attrs={'class':'yt-uix-tile-link'}):
#             #if (i<1):
#             temp='https://www.youtube.com' + vid['href']

#             temp=temp.replace("watch?v=", "embed/")

#             list_videos[str(i)] =temp
#             print (vid["href"])
#             i = i + 1
#             print ("video added")
#         for i in list_videos:
#             print (i, list_videos[i])

# #        return list_videos
#         return list_videos["3"]

# # print (getContent().get_videos("abortion"))
