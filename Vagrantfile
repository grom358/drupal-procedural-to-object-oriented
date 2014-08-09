# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# Variables.
##

box      = 'precise32'
url      = 'http://files.vagrantup.com/' + box + '.box'
domain   = 'dev'
cpus     = '1'
ram      = '768'
nodes = [
  {
    :hostname => 'd7demo',
    :ip => '192.168.1.52',
  },{
    :hostname => 'd8demo',
    :ip => '192.168.1.53',
  }
]

##
# Configuration.
##

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box       = box
      node_config.vm.box_url   = url
      node_config.vm.host_name = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, :ip => node[:ip]

      # We want to cater for both Unix and Windows.
      if RUBY_PLATFORM =~ /linux|darwin/
        node_config.vm.synced_folder(
          ".",
          "/vagrant",
          :nfs => true,
          :map_uid => 0,
          :map_gid => 0,
         )
      else
        node_config.vm.synced_folder "./" + node[:hostname], "/vagrant"
      end

      # Virtualbox provider configuration.
      node_config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm",     :id, "--cpus", cpus]
        vb.customize ["modifyvm",     :id, "--memory", ram]
        vb.customize ["modifyvm",     :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm",     :id, "--natdnsproxy1", "on"]
        vb.customize ["modifyvm",     :id, "--nicpromisc1", "allow-all"]
        vb.customize ["modifyvm",     :id, "--nicpromisc2", "allow-all"]
        vb.customize ["modifyvm",     :id, "--nictype1", "Am79C973"]
        vb.customize ["modifyvm",     :id, "--nictype2", "Am79C973"]
        vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
      end

      # Provisioners.
      node_config.vm.provision :shell, :path => "puppet/provision.sh"
      node_config.vm.provision :puppet do |puppet|
        puppet.facter = {
          'fqdn'          => node[:hostname] + '.' + domain,
          'vagrant_uid'   => Process.uid,
          'vagrant_group' => 'dialout'
        }
        puppet.manifests_path = "puppet"
        puppet.manifest_file = "site.pp"
        puppet.module_path = "puppet/modules"
      end
    end
  end
end
