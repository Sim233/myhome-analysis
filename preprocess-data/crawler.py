import requests
import os

outdir = "data/"
if not os.path.exists(outdir):
    os.makedirs(outdir)

idx = 1033
html_url = ("http://m.myhome.tsinghua.edu.cn/weixin/weixin_advice.aspx?id=%d" %(idx)) #指定要爬取的url
response = requests.get(html_url) #发送get请求
with open(os.path.join(outdir, "test.html"),'wb') as f:
    print(type(response.content))
    f.write(response.content)  #将爬取到的数据储存到D盘的pc文件夹
    print('完成爬取！！！')
