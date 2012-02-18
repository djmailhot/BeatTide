import os

emails = "aimlessrose@mail.com,alexmiller@mail.com,tjrigs@gmail.com,hsingh@cs.washington.edu,brettw07@gmail.com,djmailhot@gmail.com"

issue = raw_input("issue number (blank for new issue): ")
if issue:
    subject = raw_input("subject? ")
    os.system('python upload.py -t "' + subject + '" -r "' + emails + '" --rev origin/master --send_mail --private -i ' + issue)
else:
    subject = raw_input("subject? ")
    description = raw_input("description? ")
    os.system('python upload.py -t "' + subject + '" -m  "' + description + '" -r "' + emails + '" --rev origin/master --send_mail --private --cc="roy@cs.washington.edu"')