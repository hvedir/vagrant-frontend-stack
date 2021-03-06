# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))
  file_to_disk = File.join(VAGRANT_ROOT, '.vagrant/temp-files.vmdk')

  # Select OS better for you
  config.vm.box = 'ubuntu/trusty64'
  # config.vm.box = 'ubuntu/trusty32'

  # Dev server
  config.vm.network :forwarded_port, guest: 9000, host: 9000
  config.vm.network :forwarded_port, guest: 80, host: 8888

  # Live reload
  config.vm.network :forwarded_port, guest: 35729, host: 35729

  config.vm.provider :virtualbox do |vb|
    # Adjust memory for your system, for less than 1024 better use trusty32
    vb.customize ['modifyvm', :id, '--memory', '2048']
    # Create new disk to keep temp files, binaries and node libraries
    vb.customize ['createhd', '--filename', file_to_disk, '--size', 7 * 1024]
    vb.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
    # In case of boot issues uncomment for debug
    # vb.gui = true
  end

  separator = '----------------------------------'


  # #############################################
  # # install build tools
  config.vm.provision :shell, inline: 'apt-get update && apt-get upgrade -y'
  config.vm.provision :shell, inline: 'apt-get install -y gdisk python-software-properties python g++ make autoconf automake git-core wget curl vim mc tmux mongodb'
  # end install build tools
  #############################################

  #############################################
  # Format/configure new disk
  #--------------------------
  # The idea is to keep temporary and OS specific files on separate volume
  # which will be mounted only while VM is running
  # Other solutions like using symlinks, samba or nfs are not cross-platform
  config.vm.provision :shell, inline: 'echo -e "o\nn\np\n1\n\n+4G\nn\np\n2\n\n+2G\nn\np\n3\n\n\nw" | fdisk /dev/sdb'
  config.vm.provision :shell, inline: 'mkfs.ext4 /dev/sdb1'
  config.vm.provision :shell, inline: 'mkfs.ext4 /dev/sdb2'
  config.vm.provision :shell, inline: 'mkfs.ext4 /dev/sdb3'
  config.vm.provision :shell, inline: 'rm -rf /vagrant/node_modules'
  config.vm.provision :shell, inline: 'mkdir /vagrant/node_modules'
  config.vm.provision :shell, inline: 'echo "/dev/sdb1 /vagrant/node_modules ext4 defaults,rw,noatime 0 0" >> /etc/fstab'
  config.vm.provision :shell, inline: 'rm -rf /vagrant/.sass-cache'
  config.vm.provision :shell, inline: 'mkdir /vagrant/.sass-cache'
  config.vm.provision :shell, inline: 'echo "/dev/sdb2 /vagrant/.sass-cache ext4 defaults,rw,noatime 0 0" >> /etc/fstab'
  config.vm.provision :shell, inline: 'rm -rf /vagrant/.tmp'
  config.vm.provision :shell, inline: 'mkdir /vagrant/.tmp'
  config.vm.provision :shell, inline: 'echo "/dev/sdb3 /vagrant/.tmp ext4 defaults,rw,noatime 0 0" >> /etc/fstab'
  config.vm.provision :shell, inline: 'mount -a'
  config.vm.provision :shell, inline: 'chown -R vagrant:vagrant /vagrant/node_modules'
  config.vm.provision :shell, inline: 'chown -R vagrant:vagrant /vagrant/.sass-cache'
  config.vm.provision :shell, inline: 'chown -R vagrant:vagrant /vagrant/.tmp'
  # end Format/configure new disk
  #############################################

  #############################################
  # install Ruby
  config.vm.provision :shell, inline: 'cd /tmp'
  config.vm.provision :shell, inline: 'wget https://get.rvm.io -O ruby-installer'
  config.vm.provision :shell, inline: 'chmod +x ruby-installer'
  config.vm.provision :shell, inline: './ruby-installer --ruby'
  config.vm.provision :shell, inline: 'source /etc/profile.d/rvm.sh'
  config.vm.provision :shell, inline: 'cd ~/'
  # Ruby gems
  config.vm.provision :shell, inline: 'gem install sass compass bundler'
  # end install Ruby
  #############################################

  #############################################
  # install Nodejs
  config.vm.provision :shell, inline: 'add-apt-repository -y ppa:chris-lea/node.js'
  config.vm.provision :shell, inline: 'apt-get update'
  config.vm.provision :shell, inline: 'apt-get install -y nodejs'
  # Install latest npm
  config.vm.provision :shell, inline: 'npm install -g npm'
  # Node modules
  config.vm.provision :shell, inline: 'npm install -g bower typescript yo karma grunt-cli express generator-generator generator-angular generator-bangular phantom'
  # end install Nodejs
  #############################################

  #############################################
  # fixes, workarounds, config
  config.vm.provision :shell, inline: 'npm cache clean && chown -R vagrant:vagrant /home/vagrant/ && chown -R root:vagrant /usr/bin && chmod -R g+w /usr/bin && chown -R vagrant:root /usr/lib/node_modules'
  config.vm.provision :shell, privileged: false, inline: 'cd /vagrant && npm install'
  config.vm.provision :shell, privileged: false, inline: 'cd /vagrant && npm update'
  config.vm.provision :shell, privileged: false, inline: 'ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ""'
  $cmd = <<SCRIPT
echo "#{separator} \n\nSSH public key: \n"
cat ~/.ssh/id_rsa.pub
echo && echo #{separator} && echo && echo 'Summary: '
echo "\n Vagrant home: /home/vagrant\nApplication root: /vagrant\nForwarded ports: 9000 (connect server) and 35729 (livereload)\n\
this mean that you open http:/localhost:9000 in your browser when dev sever is running\n\
#{separator}\nHow to run dev server?\n#cd /vagrant\n[opt] #npm install\n[opt]#bower install\n#grunt serve \n\n\
!Note: Check your Gruntfile.js, if you have connect.livereload.open flag set to true, change it to false\n\
because we run application on X-less machine\n\n\
#{separator}\n#{separator}\n\nEnjoy!\n\n#{separator}\n#{separator}"
SCRIPT
  config.vm.provision :shell, privileged: false, inline: $cmd
  # end fixes, workarounds, config
  #############################################

end
