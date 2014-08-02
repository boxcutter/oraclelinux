# Grub tweaks - default to RedHat-compatible kernel
echo "==> Configuring Grub to use RedHat-compatible kernel"
if grep -q -i "release 7" /etc/redhat-release ; then
    # Grub tweaks - default to RedHat-compatible kernel
    sed -i 's/^GRUB_DEFAULT=saved/GRUB_DEFAULT=0/' /etc/default/grub
#    sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 biosdevname=0 rhgb quiet\"/" /etc/default/grub
    grub2-mkconfig -o /boot/grub2/grub.cfg
    # Fix issue with Host SMBus controller not enabled
    #echo "blacklist i2c_piix4" >> /etc/modprobe.d/blacklist.conf
    #echo "blacklist ipv6" >> /etc/modprobe.d/blacklist.conf
    #echo "blacklist autofs" >> /etc/modprobe.d/blacklist.conf
else
    sed -i 's/^default=0/default=1/' /boot/grub/grub.conf
fi

# reboot
echo "Rebooting the machine..."
reboot
sleep 60
