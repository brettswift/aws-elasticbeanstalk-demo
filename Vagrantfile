required_plugins = [
  'vagrant-triggers',
  'vagrant-hostmanager',
]

required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin) then
    raise "please run: `\e[35mvagrant plugin install #{plugin}\e[39m` as this plugin is required."
  end
end

box = "centos/7"

node_name = 'beanstalk-demo' #as required to appear in the module_path

Vagrant.configure("2") do |config|
  config.vm.define node_name do |node_config|
    host_name = "#{node_name}.vagrant"
    node_config.vm.box = box

    node_config.vm.host_name = host_name
    node_config.ssh.forward_agent = true
    # node_config.vm.network :private_network, ip: host_ip  # uncomment to specify IP

    node_config.vm.provider :virtualbox do |vb|
      vb.customize [
        'modifyvm', :id,
        '--name', host_name,
        '--memory', '500',
        '--cpus', '1'
      ]
    end

    parent_dir =  Dir.pwd
    home_dir = Dir.home
    aws_creds = `cat #{home_dir}/.aws/credentials`
    # node_config.vm.provision :shell, :inline => 'service firewalld stop;'
    node_config.vm.provision :shell, :inline => 'rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm;  yum install puppet -y >/dev/null'
    node_config.vm.provision :shell, :inline => 'puppet resource package epel-release ensure=latest'
    node_config.vm.provision :shell, :inline => 'puppet resource package python2-pip ensure=latest'
    node_config.vm.provision :shell, :inline => 'puppet resource package awsebcli ensure=latest provider=pip install_options="--upgrade --user"'
    node_config.vm.provision :shell, :inline => 'puppet resource file "/etc/profile.d/local_bin.sh" ensure=present content="export PATH=~/.local/bin:$PATH"'

    # Copy AWS credentials and config from host to guest
    $aws_credentials_path   = ENV['HOME'] + "/.aws/credentials"
    $aws_config_path        = ENV['HOME'] + "/.aws/config"
    
    if File.file?($aws_credentials_path) && File.file?($aws_config_path) then
      config.vm.provision "shell",
          inline: "mkdir -p /root/.aws",
          privileged: true
      config.vm.provision "file",
          source: $aws_credentials_path,
          destination: "/home/vagrant/.aws/credentials"
      config.vm.provision "shell",
          inline: "/bin/cp -f /home/vagrant/.aws/credentials /root/.aws/credentials",
          privileged: true
      config.vm.provision "file",
        source: $aws_config_path,
        destination: "/home/vagrant/.aws/config"
      config.vm.provision "shell",
        inline: "/bin/cp -f /home/vagrant/.aws/config /root/.aws/config",
        privileged: true
    else
      puts "AWS Credentials do not exist on host!"
    end

    # file { "/etc/profile.d/set_java_home.sh":
    #     ensure => present,
    #     source => ...[whatever's appropriate for your setup]...,
    #     ...
    # }
    # Needed so vagrant can execute commands through sudo
    # node_config.vm.provision :shell, :inline => "echo 'Defaults secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin' > /etc/sudoers.d/add_to_secure_path"

    #  node_config.vm.provision :shell,
    #   :path => 'scripts/bootstrap-puppet-enterprise.sh',
    #   :args => bootargs

    #  node_config.vm.provision :shell, :inline => "puppet resource file '/etc/puppetlabs/puppet/environments/vagrant' ensure=link target='/root/puppet_bootstrap/puppet/vagrant/control_repo'"
  end
end
