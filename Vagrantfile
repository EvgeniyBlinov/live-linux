# -*- mode: ruby -*-
# vi: set ft=ruby :

######################  libvirt  #######################################
## apt update && apt install qemu libvirt-daemon-system libvirt-clients libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev ruby-libvirt ebtables dnsmasq-base
## vagrant plugin install vagrant-libvirt
## export VAGRANT_DEFAULT_PROVIDER=libvirt
## vagrant up --provider=libvirt
#
## !!!! @TODO
## cp /bin/true /sbin/ip6tables
## apt install --reinstall iptables
#
######################  virtualbox  ####################################
## sudo modprobe vboxdrv
## sudo modprobe vboxnetadp
## sudo vboxreload
## vagrant up --provider=virtualbox
require 'socket'

hostname = Socket.gethostname
localmachineip = IPSocket.getaddress(Socket.gethostname)
puts %Q{ This machine has the IP '#{localmachineip} and host name '#{hostname}'}

box_name = 'debian/bullseye64'

NETWORK_BASE = '192.168.56'
INTEGRATION_START_SEGMENT = 10

Vagrant.configure(2) do |config|
  config.vm.box = box_name
  config.vm.network :private_network, ip: "#{NETWORK_BASE}.#{INTEGRATION_START_SEGMENT}"
  # network with ipv6 support
  config.vm.network :private_network,
    :ip => "#{NETWORK_BASE}.#{INTEGRATION_START_SEGMENT}",
    :libvirt__guest_ipv6 => "no"
  config.vm.hostname = 'linux'
  config.vm.boot_timeout = 600

  config.vm.provider "virtualbox" do |v, override|
    v.memory = 8192 # for tmpfs build
    v.cpus = 2
    override.vm.box = box_name
    provider_name = 'virtualbox'
    # Basebox ubuntu/xenial64 comes with following Vagrantfile config and causes https://github.com/joelhandwell/ubuntu_vagrant_boxes/issues/1
    # vb.customize [ "modifyvm", :id, "--uart1", "0x3F8", "4" ]
    # vb.customize [ "modifyvm", :id, "--uartmode1", "file", File.join(Dir.pwd, "ubuntu-xenial-16.04-cloudimg-console.log") ]
    # following config will address the issue
    #v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    #v.customize [ 'modifyvm', :id, '--natdnshostresolver1', 'on' ]
  end

  #config.vm.provider "libvirt" do |libvirt, override|
    #libvirt.cpus = 2
    #libvirt.memory = 2048
    #libvirt.driver = 'kvm'
    #libvirt.host = 'localhost'
    #libvirt.uri = 'qemu:///system'
    #override.vm.box = box_name
    #provider_name = 'libvirt'
    #libvirt.management_network_guest_ipv6 = "no"
  #end

  config.vm.synced_folder ".", "/vagrant/live-linux"

  config.vm.provision "shell", path: "./vagrant-provision/vagrant-install-software.sh", run: "always"
  config.vm.provision "shell", path: "./vagrant-provision/vagrant-live-linux-depends.sh", run: "always"

end
