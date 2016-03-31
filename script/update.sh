#!/bin/bash -eux

if [ $UPDATE != 0 ]
then
  if [ $DOCKER != 0 ]
  then

    echo "==> Adding UEKR4 repo to update to 4.1 kernel for docker support"
    cat << EOF >> /etc/yum.repos.d/public-yum-ol7.repo

[ol7_UEKR4]
name=Latest Unbreakable Enterprise Kernel Release 4 for Oracle Linux $releasever (x86_64)
baseurl=http://yum.oracle.com/repo/OracleLinux/OL7/UEKR4/x86_64
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=1
EOF
  fi

  if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
      echo "==> Applying updates"
      yum -y update

      # reboot
      echo "Rebooting the machine..."
      reboot
      sleep 60
  fi
fi
