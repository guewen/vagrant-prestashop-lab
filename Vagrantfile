# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  project_name = "Prestashop"

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "lucid32_base"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
   config.vm.boot_mode = :gui

  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  config.vm.network "33.33.33.100"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port "http", 80, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file base.pp in the manifests_path directory.
  config.vm.provision :puppet do |puppet|
    # for debug, uncomment
    puppet.options = "--verbose --debug"
    # for verbose, uncomment
    puppet.options = "--verbose"
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
  end

  config.vm.customize do |vm|
    vm.memory_size = 1024
    vm.name = "#{project_name} Development and Test Instance"
  end

  config.ssh.max_tries = 150

end
