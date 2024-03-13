from datetime import datetime
import OpenSSL
import ssl
def getexpiredate(url):
        cert=ssl.get_server_certificate((url, 443))
        x509 = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_PEM, cert)
        bytes=x509.get_notAfter()
        timestamp = bytes.decode('utf-8')
        expiredate=datetime.strptime(timestamp, '%Y%m%d%H%M%S%z').strftime("%Y-%m-%d %H:%M")
        expiredate=datetime.strptime(expiredate,'%Y-%m-%d %H:%M')
        return expiredate

url='https://takamol.sy'

expdate=getexpiredate(url=url[url.index('https://')+8:])
t=(expdate-datetime.now())
days=str(t)
days=days[0:days.index('days')+4]+' & '+days[days.index(', ')+2:days.index(', ')+4]+' hours'
print(days)



