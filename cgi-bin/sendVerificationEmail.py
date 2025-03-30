#/usr/bin/env python
from hashlib import sha256
import telnetlib

def telMail(email, link):
    tn = telnetlib.Telnet("smtp.unb.ca", 25)
    rcpt = "RCPT TO: " + email + "\r\n"
    message = "DATA\nFrom: unbtube-validation@unb.ca\nTo: " + email + "\nSubject: Verification Link\nMIME-Version:1.0\nContent-Type:text/html\nHere is your verification link: <a href=\"" + link + "\">Click Here" + "</a>" + "<br>" + "It will expire in 15 minutes.\r\n"
    tn.write(b"HELO unb.ca\r\n")
    tn.write(b"MAIL FROM: unbtube-validation@unb.ca\r\n")
    tn.write(rcpt.encode('utf-8'))
    tn.write(message.encode('utf-8'))
    tn.write(b".\r\n")
    tn.close()
