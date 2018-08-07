echo "==> Removing all linux kernels except the currrent one"
dpkg --list | awk '{ print $2 }' | grep -e 'linux-\(headers\|image\)-.*[0-9]\($\|-generic\)' | grep -v "$(uname -r | sed 's/-generic//')" | xargs apt-get -y purge

echo "==> Removing linux source"
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge

echo "==> Removing development packages"
dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge

echo "==> Removing documentation"
dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge

echo "==> Removing development tools"
apt-get -y purge build-essential git

echo "==> Removing default system Ruby"
apt-get -y purge ruby ri doc

echo "==> Removing X11 libraries"
#apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6

echo "==> Removing obsolete networking components"
apt-get -y purge ppp pppconfig pppoeconf

echo "==> Removing other oddities"
apt-get -y purge popularity-contest installation-report landscape-common wireless-tools wpasupplicant ubuntu-serverguide
apt-get -y purge linux-image-3.0.0-12-generic-pae
apt-get -y purge python-dbus libnl1 python-smartpm python-twisted-core libiw30
apt-get -y purge python-twisted-bin libdbus-glib-1-2 python-pexpect python-pycurl python-serial python-gobject python-pam python-openssl libffi5

apt-get -y install deborphan

while [ -n "$(deborphan --guess-all --libdevel)" ]; do
    deborphan --guess-all --libdevel | xargs apt-get -y purge
done

apt-get -y purge deborphan dialog
apt-get -y autoremove
apt-get -y clean

echo "==> Removing APT files"
rm -rf /var/lib/apt/lists/*

echo "==> Removing any docs"
rm -rf /usr/share/doc/*
rm -Rf /usr/share/man

echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;

echo "==> Truncating logs"
find /var/log -type f | while read f; do echo -ne '' > "${f}"; done;

echo "==> Cleaning up tmp"
rm -rf /usr/src/vboxguest*
rm -rf /tmp/*
