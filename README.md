# Ansible - GitLab

A set of [Ansible][1] roles to configure a RASPBERRY PI which serves as Scanner server.

Included components:

- Initial server setup
- Postfix for smtp relay
- NTP client
- unattended upgrade

Custom [Ansible Roles][3] are located in the `roles` directory. Each `role` might have it's own `README.md` with further documentation.

## Getting Started

On host system activate ssh server and install `sshpass` to send passwords to SSH

    sudo raspi-config
OR
    sudo /etc/init.d/ssh start
    sudo update-rc.d ssh defaults

    sudo apt-get install sshpass

Install dependencies from [Ansible Galaxy][4]:

    grep 'name:' requirements.yml | awk -F: '{print $2}' | xargs -I {} sudo ansible-galaxy remove {}
    sudo ansible-galaxy install -r requirements.yml
or
    sh ansible-galaxy-update-roles.sh

Create an [Ansible Inventory][5] file, e.g. name it `hosts.cfg`:

    [development]
    # raspberrypi-dev ansible_host=10.6.7.29 ansible_port=22 ansible_user=vagrant

    [production]
    # If you create the user "vagrant", set the ansible_user to root
    # raspberrypi ansible_host=10.6.7.29 ansible_port=22 ansible_user=pi
    #raspberrypi ansible_host=10.6.7.29 ansible_port=22 ansible_user=vagrant


Create remote user `vagrant` and copy the public key:

    ansible-playbook --inventory-file=hosts.cfg setup.yml -l development --ask-pass
    ansible-playbook --inventory-file=hosts.cfg setup.yml -l production --ask-pass

Create `ansible.cfg` in the same folder as your inventory file to disable host key check:

    [defaults]
    host_key_checking=false

Run your custom [Ansible Playbook][2]:

    ansible-playbook --inventory-file=hosts.cfg raspian-playbook.yml -l development
    ansible-playbook --inventory-file=hosts.cfg raspian-playbook.yml -l production

## Useful steps

### (Re-)Generate new ssh server keys

Most Linux and Unix distribution create ssh keys for you during the installation of the OpenSSH server package. But it may be useful to be able re-generate new server keys from time to time. For example, when you duplicate VM (KVM or container) which contains an installed ssh package and you need to use different keys from cloned machine.

Step # 1: Delete old ssh host keys
Login as the root and type the following command to delete files on your SSHD server:

    rm -v /etc/ssh/ssh_host_*

Step # 2: Restart OpenSSH Server to regnerate new files

    service sshd restart

### Use latest RASPBIAN lite image

Download RASPBIAN STRETCH LITE Minimal image based on Debian Stretch
https://www.raspberrypi.org/downloads/raspbian/
https://downloads.raspberrypi.org/raspbian_lite_latest

Install .IMG file to SD card
 dd bs=4M if=2018-03-13-raspbian-stretch-lite.img of=/dev/sdd conv=fsync

To login use username `pi` with password `raspberry`

## Links to checkout later

Build sane from source
https://help.ubuntu.com/community/CompileSaneFromSource
https://askubuntu.com/questions/203560/building-sane-from-git-source-produce-backend-missmatch-on-12-04-even-if-built-l?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
https://www.howtoinstall.co/en/ubuntu/trusty/libsane?action=remove

Build scanbd from source
http://virantha.com/2014/03/17/one-touch-scanning-with-fujitsu-scansnap-in-linux/

http://artem.gratchev.com/2015/01/home-scan-station-based-on-raspberry-pi/
http://johannesnews.blogspot.de/2013/02/scan-to-email-with-only-one-buttonpress.html

https://www.jduck.net/blog/2008/01/05/ocr-scanning/
http://blog.braier.net/2014/05/scannen-kopieren-per-shell-script/


[1]: https://www.ansible.com "Ansible"
[2]: https://docs.ansible.com/ansible/playbooks.html "Ansible Playbook"
[3]: https://docs.ansible.com/ansible/playbooks_roles.html "Ansible Roles"
[4]: https://galaxy.ansible.com "Ansible Galaxy"
[5]: https://docs.ansible.com/ansible/intro_inventory.html "Ansible Inventory"
