# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :mirror do |mirror_config|
    mirror_config.vm.box       = "precise32"
    mirror_config.vm.box_url   = "http://files.vagrantup.com/precise32.box"
    mirror_config.vm.boot_mode = :gui

    mirror_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "mirror.pp"
    end
  end
end
