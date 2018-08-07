echo "==> Installing insecure vagrant key"
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "==> Installing VirtualBox guest additions"
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm /home/vagrant/VBoxGuestAdditions.iso
rm /home/vagrant/.vbox_version
