#!/bin/bash
syslog_ip=172.17.0.240
NAMES=`dirname $0`/names.txt

# backup
cp /etc/pam.d/sshd /etc/pam.d/sshd.bak
cp /etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.conf.bak

# import names.txt
exec < $NAMES
while read username
do
    useradd -m $username -s /bin/bash
    echo "$username:$username"|chpasswd
done

# run showterm right after login from bashrc
cat >> /etc/bash.bashrc << _EOF_
if [ -z \$already_asciinema ]; then
export already_asciinema=true
asciinema rec /var/log/honii/asciinema_\`whoami\`_\`date +%s\`.json
exit
fi
_EOF_

#install PAM
mark_line=`grep -n "include common-auth" /etc/pam.d/sshd | awk -F: '{print $1}'`
((mark_line++))
sed -i 's/@include common-auth/#@include common-auth/g' /etc/pam.d/sshd
line="iauth       requisite     pam_python.so pwreveal.py"
line=$mark_line$line
sed -i "$line" /etc/pam.d/sshd

apt-get -y install libpam-python

#echo "honeypot                        @$syslog_ip" > /etc/rsyslog.d/50-default.conf
