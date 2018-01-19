# gitver

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with gitver](#setup)
    * [What gitver affects](#what-gitver-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with gitver](#beginning-with-gitver)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
INTEGRATION NOTES:

Below are my notes i recorded when i attempted to integrate simp on 2018-JAN-19.

It did not run.  The last thing I worked on was trying to read and print out the
hiera data.  The site.pp had trouble instantiating simp_options too.

MY NOTES:


#simp
#install

Source:
http://simp.readthedocs.io/en/6.1.0-0/getting_started_guide/Preparing_For_Non_Rpm_Install.html#preparing-for-non-rpm-install
http://simp.readthedocs.io/en/6.1.0-0/getting_started_guide/Installing_SIMP_using_r10k.html
http://simp.readthedocs.io/en/6.1.0-0/user_guide/HOWTO/Control_Repo.html
http://simp.readthedocs.io/en/6.1.0-0/getting_started_guide/Initial_Configuration.html#initial-configuration


# start with "3.6. Installing SIMP Using r10k or Code Manager"

[root@puppet var]# mkdir -p /var/simp/environments/production/site_files
[root@puppet var]# mkdir -p /var/simp/environments/production/site_files/modules
[root@puppet var]# mkdir -p /var/simp/environments/production/site_files/modules/pki_files
[root@puppet var]# mkdir -p /var/simp/environments/production/site_files/modules/pki_files\files
[root@puppet var]# mkdir -p /var/simp/environments/production/site_files/modules/pki_files/files/keydist
[root@puppet var]# chown root.puppet /var/simp/environments/production/site_files
chown: invalid user: ‘root.puppet’
[root@puppet var]# mkdir -p /var/simp/environments/simp_dev
[root@puppet var]# mkdir -p /var/simp/environments/simp_dev/site_files
[root@puppet var]# mkdir -p /var/simp/environments/simp_dev/site_files/modules
[root@puppet var]# mkdir -p /var/simp/environments/simp_dev/site_files/modules/pki_files
[root@puppet var]# mkdir -p /var/simp/environments/simp_dev/site_files/modules/pki_files\files
[root@puppet var]# mkdir -p /var/simp/environments/simp_dev/site_files/modules/pki_files\files\keydist
[root@puppet var]# mkdir -p /var/simp/environments/simp_dev/site_files/simp_autofiles
[root@puppet var]# mkdir -p /var/simp/environments/production/site_files/simp_autofiles


Jeffs-MacBook-Pro:simp_dev jeff$ mkdir -p /tmp/simp-rsync
Jeffs-MacBook-Pro:simp_dev jeff$ cd /tmp/simp-rsync/
Jeffs-MacBook-Pro:simp-rsync jeff$ git clone https://github.com/simp/simp-rsync.git /tmp/simp-rsync
Cloning into '/tmp/simp-rsync'...
remote: Counting objects: 205, done.
remote: Total 205 (delta 0), reused 0 (delta 0), pack-reused 205
Receiving objects: 100% (205/205), 53.12 KiB | 1.06 MiB/s, done.
Resolving deltas: 100% (57/57), done.
Jeffs-MacBook-Pro:simp-rsync jeff$ ll
total 64
drwxr-xr-x  13 jeff  wheel   416 Jan 17 15:19 .git/
-rw-r--r--   1 jeff  wheel   180 Jan 17 15:19 .gitignore
-rw-r--r--   1 jeff  wheel   475 Jan 17 15:19 .travis.yml
-rw-r--r--   1 jeff  wheel   197 Jan 17 15:19 CONTRIBUTING.md
-rw-r--r--   1 jeff  wheel   862 Jan 17 15:19 Gemfile
-rw-r--r--   1 jeff  wheel  1012 Jan 17 15:19 LICENSE
-rw-r--r--   1 jeff  wheel  2250 Jan 17 15:19 README.md
-rw-r--r--   1 jeff  wheel  4201 Jan 17 15:19 Rakefile
drwxr-xr-x   4 jeff  wheel   128 Jan 17 15:19 build/
drwxr-xr-x   3 jeff  wheel    96 Jan 17 15:19 environments/
Jeffs-MacBook-Pro:simp-rsync jeff$

# on puppet master...

Jeffs-MacBook-Pro:simp-rsync jeff$ pwd
/tmp/simp-rsync
Jeffs-MacBook-Pro:simp-rsync jeff$ git clone https://github.com/simp/simp-rsync.git /tmp/simp-rsync
Cloning into '/tmp/simp-rsync'...
remote: Counting objects: 205, done.
remote: Total 205 (delta 0), reused 0 (delta 0), pack-reused 205
Receiving objects: 100% (205/205), 53.12 KiB | 1.06 MiB/s, done.
Resolving deltas: 100% (57/57), done.
Jeffs-MacBook-Pro:simp-rsync jeff$ ll
total 64
drwxr-xr-x  13 jeff  wheel   416 Jan 17 15:19 .git/
-rw-r--r--   1 jeff  wheel   180 Jan 17 15:19 .gitignore
-rw-r--r--   1 jeff  wheel   475 Jan 17 15:19 .travis.yml
-rw-r--r--   1 jeff  wheel   197 Jan 17 15:19 CONTRIBUTING.md
-rw-r--r--   1 jeff  wheel   862 Jan 17 15:19 Gemfile
-rw-r--r--   1 jeff  wheel  1012 Jan 17 15:19 LICENSE
-rw-r--r--   1 jeff  wheel  2250 Jan 17 15:19 README.md
-rw-r--r--   1 jeff  wheel  4201 Jan 17 15:19 Rakefile
drwxr-xr-x   4 jeff  wheel   128 Jan 17 15:19 build/
drwxr-xr-x   3 jeff  wheel    96 Jan 17 15:19 environments/
Jeffs-MacBook-Pro:simp-rsync jeff$ pwd
/tmp/simp-rsync

# on dev machine...

Jeffs-MacBook-Pro:simp-rsync jeff$
Jeffs-MacBook-Pro:simp-rsync jeff$ scp -r /tmp/simp-rsync/ root@192.168.0.136:/tmp/
root@192.168.0.136's password:
LICENSE                                                                                                     100% 1012   524.8KB/s   00:00    
README                                                                                                      100%  965   161.9KB/s   00:00    
.rsync.facl                                                                                                 100% 9818     4.1MB/s   00:00    
LICENSE                                                                                                     100%  815   182.1KB/s   00:00    
your.domain                                                                                                 100%  150   121.7KB/s   00:00    
named.conf                                                                                                  100% 1808     1.6MB/s   00:00    
rndc.key                                                                                                    100%  113   135.7KB/s   00:00    
named.broadcast                                                                                             100%  427   377.0KB/s   00:00    
named.ip6.local                                                                                             100%  424   392.9KB/s   00:00    
named.zero                                                                                                  100%  427   381.9KB/s   00:00    
named.root                                                                                                  100% 1892     2.1MB/s   00:00    
0.0.10.db                                                                                                   100%  193   173.1KB/s   00:00    
my.ddns.internal.zone.db                                                                                    100%   56    53.1KB/s   00:00    
my.slave.internal.zone.db                                                                                   100%   56    60.0KB/s   00:00    
named.local                                                                                                 100%  426   396.2KB/s   00:00    
named_mem_stats.txt                                                                                         100% 5117     4.2MB/s   00:00    
localhost.zone                                                                                              100%  195   169.1KB/s   00:00    
your.domain.db                                                                                              100%  227   231.4KB/s   00:00    
localdomain.zone                                                                                            100%  198   125.6KB/s   00:00    
named.pid                                                                                                   100%    5     4.6KB/s   00:00    
.shares                                                                                                     100%   57    46.9KB/s   00:00    
LICENSE                                                                                                     100%  815   642.4KB/s   00:00    
your.domain                                                                                                 100%  150   117.9KB/s   00:00    
named.conf                                                                                                  100% 1768     1.6MB/s   00:00    
rndc.key                                                                                                    100%  113    74.3KB/s   00:00    
named.broadcast                                                                                             100%  427    99.5KB/s   00:00    
named.ip6.local                                                                                             100%  424   354.8KB/s   00:00    
named.zero                                                                                                  100%  427   369.7KB/s   00:00    
named.root                                                                                                  100% 1892     1.8MB/s   00:00    
0.0.10.db                                                                                                   100%  193   218.9KB/s   00:00    
my.ddns.internal.zone.db                                                                                    100%   56    68.6KB/s   00:00    
my.slave.internal.zone.db                                                                                   100%   56    67.5KB/s   00:00    
named.local                                                                                                 100%  426   438.4KB/s   00:00    
named_mem_stats.txt                                                                                         100% 5117     3.1MB/s   00:00    
localhost.zone                                                                                              100%  195   224.6KB/s   00:00    
your.domain.db                                                                                              100%  227   256.6KB/s   00:00    
localdomain.zone                                                                                            100%  198   223.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
named.pid                                                                                                   100%    5     6.4KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.shares                                                                                                     100%   57    64.7KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
LICENSE                                                                                                     100%  815   651.3KB/s   00:00    
dhcpd.conf                                                                                                  100%  674   758.3KB/s   00:00    
.shares                                                                                                     100%   57    44.9KB/s   00:00    
README                                                                                                      100%  340   261.2KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.gitignore                                                                                                  100%    0     0.0KB/s   00:00    
.shares                                                                                                     100%   57    42.4KB/s   00:00    
.gitignore                                                                                                  100%   12     9.2KB/s   00:00    
README.md                                                                                                   100% 2250     1.6MB/s   00:00    
Rakefile                                                                                                    100% 4201     2.8MB/s   00:00    
.gitignore                                                                                                  100%  180    30.8KB/s   00:00    
CONTRIBUTING.md                                                                                             100%  197   170.6KB/s   00:00    
Gemfile                                                                                                     100%  862   630.6KB/s   00:00    
simp-rsync.spec                                                                                             100%   12KB   7.0MB/s   00:00    
freshclam.conf                                                                                              100% 2145     1.6MB/s   00:00    
config                                                                                                      100%  308   309.5KB/s   00:00    
pack-635f40315a29572a122411f8f3e2aada01451a5c.pack                                                          100%   53KB  20.8MB/s   00:00    
pack-635f40315a29572a122411f8f3e2aada01451a5c.idx                                                           100% 6812     6.1MB/s   00:00    
HEAD                                                                                                        100%   23    21.1KB/s   00:00    
exclude                                                                                                     100%  240   206.3KB/s   00:00    
HEAD                                                                                                        100%  190   167.0KB/s   00:00    
master                                                                                                      100%  190   180.5KB/s   00:00    
HEAD                                                                                                        100%  190   132.4KB/s   00:00    
description                                                                                                 100%   73    63.3KB/s   00:00    
commit-msg.sample                                                                                           100%  896   379.9KB/s   00:00    
pre-rebase.sample                                                                                           100% 4898     2.6MB/s   00:00    
pre-commit.sample                                                                                           100% 1642     1.4MB/s   00:00    
applypatch-msg.sample                                                                                       100%  478   438.3KB/s   00:00    
pre-receive.sample                                                                                          100%  544   460.4KB/s   00:00    
prepare-commit-msg.sample                                                                                   100% 1239   924.3KB/s   00:00    
post-update.sample                                                                                          100%  189    45.8KB/s   00:00    
pre-applypatch.sample                                                                                       100%  424   314.6KB/s   00:00    
pre-push.sample                                                                                             100% 1348   991.3KB/s   00:00    
update.sample                                                                                               100% 3610     2.7MB/s   00:00    
master                                                                                                      100%   41    47.6KB/s   00:00    
HEAD                                                                                                        100%   32    28.3KB/s   00:00    
index                                                                                                       100%   10KB   9.4MB/s   00:00    
packed-refs                                                                                                 100%  882     1.0MB/s   00:00    
.travis.yml                                                                                                 100%  475   337.4KB/s   00:00    
Jeffs-MacBook-Pro:simp-rsync jeff$


# on puppet master

mv -f /tmp/simp-rsync/environments/simp/rsync/ /var/simp/environments/simp_dev/

ln -s /var/simp/environments/simp_dev/rsync/RedHat/ /var/simp/environments/simp_dev/rsync/CentOS

# skipping...
# If simp_options::clamav is set to true, the following step is required, otherwise you can skip it.

# url in doc is wrong --> curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh.rpm | bash
# found this on web...
curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh | sudo bash

.
.
.

[root@puppet simp-rsync]# curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh.rpm | bash
bash: line 1: syntax error near unexpected token `newline'
bash: line 1: `<!DOCTYPE html>'
[root@puppet simp-rsync]# curl -s https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/script.rpm.sh | sudo bash
Detected operating system as centos/7.
Checking for curl...
Detected curl...
Downloading repository file: https://packagecloud.io/install/repositories/simp-project/6_X_Dependencies/config_file.repo?os=centos&dist=7&source=script
done.
Installing pygpgme to verify GPG signatures...
Loaded plugins: fastestmirror, langpacks
simp-project_6_X_Dependencies-source/signature                                                                                                                                                 |  836 B  00:00:00     
Retrieving key from https://packagecloud.io/simp-project/6_X_Dependencies/gpgkey
Importing GPG key 0xEBE5642E:
 Userid     : "https://packagecloud.io/simp-project/6_X_Dependencies (https://packagecloud.io/docs#gpg_signing) <support@packagecloud.io>"
 Fingerprint: 757f 6e95 47bf fb41 e2fc 5e35 7909 0a18 ebe5 642e
 From       : https://packagecloud.io/simp-project/6_X_Dependencies/gpgkey
simp-project_6_X_Dependencies-source/signature                                                                                                                                                 |  951 B  00:00:00 !!!
simp-project_6_X_Dependencies-source/primary                                                                                                                                                   |  175 B  00:00:11     
Loading mirror speeds from cached hostfile
 * base: mirrors.syringanetworks.net
 * extras: mirrors.syringanetworks.net
 * updates: mirrors.syringanetworks.net
Package pygpgme-0.3-9.el7.x86_64 already installed and latest version
Nothing to do
Installing yum-utils...
Loaded plugins: fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * base: mirrors.syringanetworks.net
 * extras: mirrors.syringanetworks.net
 * updates: mirrors.syringanetworks.net
Resolving Dependencies
--> Running transaction check
---> Package yum-utils.noarch 0:1.1.31-40.el7 will be updated
---> Package yum-utils.noarch 0:1.1.31-42.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

======================================================================================================================================================================================================================
 Package                                             Arch                                             Version                                                    Repository                                      Size
======================================================================================================================================================================================================================
Updating:
 yum-utils                                           noarch                                           1.1.31-42.el7                                              base                                           117 k

Transaction Summary
======================================================================================================================================================================================================================
Upgrade  1 Package

Total size: 117 k
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : yum-utils-1.1.31-42.el7.noarch                                                                                                                                                                     1/2
  Cleanup    : yum-utils-1.1.31-40.el7.noarch                                                                                                                                                                     2/2
  Verifying  : yum-utils-1.1.31-42.el7.noarch                                                                                                                                                                     1/2
  Verifying  : yum-utils-1.1.31-40.el7.noarch                                                                                                                                                                     2/2

Updated:
  yum-utils.noarch 0:1.1.31-42.el7                                                                                                                                                                                    

Complete!
Generating yum cache for simp-project_6_X_Dependencies...
Importing GPG key 0xEBE5642E:
 Userid     : "https://packagecloud.io/simp-project/6_X_Dependencies (https://packagecloud.io/docs#gpg_signing) <support@packagecloud.io>"
 Fingerprint: 757f 6e95 47bf fb41 e2fc 5e35 7909 0a18 ebe5 642e
 From       : https://packagecloud.io/simp-project/6_X_Dependencies/gpgkey

The repository is setup! You can now install packages.
[root@puppet simp-rsync]#


# on dev machine

curl -o Puppetfile https://raw.githubusercontent.com/simp/simp-core/master/Puppetfile.stable

[root@puppet simp-other]# curl -o Puppetfile https://raw.githubusercontent.com/simp/simp-core/master/Puppetfile.stable
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 14964  100 14964    0     0   2645      0  0:00:05  0:00:05 --:--:--  3612
[root@puppet simp-other]#


# on dev machine

# NOTE: the preceding ":" in the file below seems strange (earlier hiera version?
#       see further below for my modified version...

$ vi hiera.yaml

---

# This is the default hiera.yaml file
# Feel free to modify the hierarchy to suit your needs but please
# leave the simp* entries in place at the bottom of the list
:backends:
  - 'yaml'
  - 'json'
:hierarchy:
  - 'hosts/%{trusted.certname}'
  - 'hosts/%{facts.fqdn}'
  - 'hosts/%{facts.hostname}'
  - 'domains/%{facts.domain}'
  - '%{facts.os.family}'
  - '%{facts.os.name}/%{facts.os.release.full}'
  - '%{facts.os.name}/%{facts.os.release.major}'
  - '%{facts.os.name}'
  - 'hostgroups/%{::hostgroup}'
  - 'default'
  - 'compliance_profiles/%{::compliance_profile}'
  - 'simp_config_settings'
  - 'scenarios/%{::simp_scenario}'
:logger: 'puppet'
# When specifying a datadir:
# # 1) Make sure the directory exists
# # 2) Make sure the directory reflects the hierarchy
:yaml:
  :datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata'
:json:
  :datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata'



$ vi hiera.yaml

---
version: 5
defaults:
  datadir: "hieradata"
# This is the default hiera.yaml file
# Feel free to modify the hierarchy to suit your needs but please
# leave the simp* entries in place at the bottom of the list
backends:
  - 'yaml'
  - 'json'
hierarchy:
  - 'hosts/%{trusted.certname}'
  - 'hosts/%{facts.fqdn}'
  - 'hosts/%{facts.hostname}'
  - 'domains/%{facts.domain}'
  - '%{facts.os.family}'
  - '%{facts.os.name}/%{facts.os.release.full}'
  - '%{facts.os.name}/%{facts.os.release.major}'
  - '%{facts.os.name}'
  - 'hostgroups/%{::hostgroup}'
  - 'default'
  - 'compliance_profiles/%{::compliance_profile}'
  - 'simp_config_settings'
  - 'scenarios/%{::simp_scenario}'
logger: 'puppet'
# When specifying a datadir:
# # 1) Make sure the directory exists
# # 2) Make sure the directory reflects the hierarchy
yaml:
  datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata'
json:
  datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata'



#environment.conf

# NOTE: 	My environment was called "simp_dev" instead of "simp" prompting a change...
		#modulepath = modules:/var/simp/environments/simp/site_files:$basemodulepath
		modulepath = modules:/var/simp/environments/simp_dev/site_files:$basemodulepath

# NOTE:	This file came from:
		simp-environment-skeleton/environments/simp/environment.conf
		https://github.com/simp/simp-environment-skeleton/blob/master/environments/simp/environment.conf

environment.conf

## Puppet Enterprise requires $basemodulepath; see note below under "modulepath".
#modulepath = site:modules:$basemodulepath
#modulepath = modules:/var/simp/environments/simp/site_files:$basemodulepath
modulepath = modules:/var/simp/environments/simp_dev/site_files:$basemodulepath
environment_timeout = 0



clear ; a=`date` ; puppet code deploy simp_dev --wait ; b=`date` ; echo "Start: ${a}" ; echo "Ended: ${b}"


# DIDNT WORK, NO CLASSES SHOWED UP.

# removed other moduledir in Puppetfile per docs...
# Source:
# http://simp.readthedocs.io/en/6.1.0-0/user_guide/HOWTO/Control_Repo.html

removed stuff between

moduledir src

# up to but not including

moduledir src/puppet/modules

e.g.

moduledir 'src'

mod 'simp-doc',
  :git => 'https://github.com/simp/simp-doc',
  :ref => '79c18f732f6c73b8bff21809c639771a892722f2'

mod 'simp-rsync',
  :git => 'https://github.com/simp/simp-rsync',
  :ref => 'd03a15bfbdb7fd756b71e3e8e10b2fc7bbaa9f31'

moduledir 'src/assets'

mod 'simp-adapter',
  :git => 'https://github.com/simp/simp-adapter',
  :ref => '6d8208fb618bdb4e05e7696a76686bb8010dc6a1'

mod 'simp-environment',
  :git => 'https://github.com/simp/simp-environment-skeleton',
  :ref => '733d59986c7fd1cd87dcbc56a04ac82a0f5f2d30'

mod 'simp-gpgkeys',
  :git => 'https://github.com/simp/simp-gpgkeys',
  :ref => '0cb94266ee5f02822cf6ed99df6d2597f39a26e6'

mod 'simp-utils',
  :git => 'https://github.com/simp/simp-utils',
  :ref => '1828ea0d02f6c8a3277cffb0bbddc272afa9c93f'

moduledir 'src/rubygems'

mod 'rubygem-simp_cli',
  :git => 'https://github.com/simp/rubygem-simp-cli',
  :ref => '7e724639c8e036d651ec81d59ec67417c3c52eb9'

# vvvvvvvvvv KEEP vvvvvvvvvv

moduledir 'src/puppet/modules'

mod 'bfraser-grafana',
  :git => 'https://github.com/simp/puppet-grafana',
  :ref => '6d426d5ccc52ff23dbbcfc45290dafd224b5d2bc'


.
.
.


# Edited environment.conf (not picking up simp modules)
# Added "/etc/puppetlabs/code/environments/simp_dev/src/puppet/modules:"

modulepath = modules:/etc/puppetlabs/code/environments/simp_dev/src/puppet/modules:/var/simp/environments/simp_dev/site_files:$basemodulepath
environment_timeout = 0


# RESTART PUPPETSERVER

# not sure if just service or whole machine
# need to do to pickup new modules and classes (I think a change to environment.conf requires a restart.




# RAN SUCCESSFULLY ON AGENT, BUT DIDNT HARDEN ANYTHING.



# Found error in puppetserver.log

1-18 14:15:58,731 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for dhcp failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,732 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for tftpboot failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,732 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for augeasproviders_grub failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,733 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for libreswan failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,733 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for file_concat failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,734 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for gpasswd failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,734 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for simp_grafana failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,735 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for datacat failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,735 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for network failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,735 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for augeasproviders_shellvar failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:15:58,736 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for simpcat failed with: undefined method `translation_repositories' for GettextSetup:Module


# fix
# Source:
# https://tickets.puppetlabs.com/browse/DOCUMENT-711

puppetserver gem update gettext-setup 0.26
systemctl restart pe-puppetserver.service
tail -n 400 /var/log/puppetlabs/puppetserver/puppetserver.log

# works...

2018-01-18 14:26:31,640 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_postgresql failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,640 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_puppet_authorization failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,641 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_r10k failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,641 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_razor failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,642 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_repo failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,642 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_staging failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,642 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_support_script failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,643 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for puppet_enterprise failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:32,466 INFO  [qtp731307611-82] [puppetserver] Puppet 'store_report' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID 770aadef-5d00-41f1-b525-bc0e3ca6bbcc
[root@puppet manifests]#
[root@puppet manifests]#
[root@puppet manifests]#
[root@puppet manifests]#
[root@puppet manifests]#
[root@puppet manifests]#
[root@puppet manifests]# puppetserver gem update gettext-setup 0.26
Updating installed gems
Nothing to update
[root@puppet manifests]# puppetserver gem list gettext-setup

*** LOCAL GEMS ***

gettext-setup (0.29, 0.8)
[root@puppet manifests]# systemctl restart pe-puppetserver.service
[root@puppet manifests]#
[root@puppet manifests]#
[root@puppet manifests]# tail -n 400 /var/log/puppetlabs/puppetserver/puppetserver.log
2018-01-18 14:26:31,639 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_java_ks failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,639 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_manager failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,639 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_nginx failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,640 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_postgresql failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,640 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_puppet_authorization failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,641 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_r10k failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,641 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_razor failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,642 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_repo failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,642 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_staging failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,642 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for pe_support_script failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:31,643 WARN  [qtp731307611-87] [puppetserver] Puppet GettextSetup initialization for puppet_enterprise failed with: undefined method `translation_repositories' for GettextSetup:Module
2018-01-18 14:26:32,466 INFO  [qtp731307611-82] [puppetserver] Puppet 'store_report' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID 770aadef-5d00-41f1-b525-bc0e3ca6bbcc
2018-01-18 14:35:17,656 INFO  [Thread-2] [p.t.internal] Shutting down due to JVM shutdown hook.
2018-01-18 14:35:17,666 INFO  [Thread-2] [p.t.internal] Beginning shutdown sequence
2018-01-18 14:35:17,688 INFO  [async-dispatch-3] [p.e.s.j.pe-jruby-metrics-service] PE JRuby Metrics Service: stopping metrics sampler job
2018-01-18 14:35:17,695 INFO  [async-dispatch-3] [p.e.s.j.pe-jruby-metrics-service] PE JRuby Metrics Service: stopped metrics sampler job
2018-01-18 14:35:17,696 INFO  [async-dispatch-3] [p.e.s.f.file-sync-client-service] Stopping file sync client service
2018-01-18 14:35:17,696 INFO  [async-dispatch-3] [p.e.s.f.file-sync-client-service] Waiting for scheduled jobs to complete
2018-01-18 14:35:21,535 INFO  [async-dispatch-3] [p.e.s.f.file-sync-client-service] scheduled jobs completed, closing HTTP client
2018-01-18 14:35:21,574 INFO  [clojure-agent-send-pool-1] [p.s.j.i.jruby-agents] Flush request received; creating new JRuby pool.
2018-01-18 14:35:21,581 INFO  [clojure-agent-send-pool-1] [p.s.j.i.jruby-agents] Replacing old JRuby pool with new instance.
2018-01-18 14:35:21,581 INFO  [clojure-agent-send-pool-1] [p.s.j.i.jruby-agents] Swapped JRuby pools, beginning cleanup of old pool.
2018-01-18 14:35:21,609 INFO  [clojure-agent-send-pool-1] [p.s.j.i.jruby-internal] Cleaned up old JRubyInstance with id 1.
2018-01-18 14:35:21,621 INFO  [clojure-agent-send-pool-1] [p.s.j.i.jruby-internal] Cleaned up old JRubyInstance with id 2.
2018-01-18 14:35:21,629 INFO  [async-dispatch-3] [p.c.services] Shutting down code-manager...
2018-01-18 14:35:21,630 INFO  [async-dispatch-3] [p.c.shell-workers] Attempting to shut down deploy-pool workers...
2018-01-18 14:35:21,633 INFO  [async-dispatch-3] [p.c.shell-workers] deploy-pool workers sucessfully shut down.
2018-01-18 14:35:21,633 INFO  [async-dispatch-3] [p.c.services] code-manager shut down.
2018-01-18 14:35:21,634 INFO  [async-dispatch-3] [p.e.s.f.file-sync-storage-service] Closing all client status channels
2018-01-18 14:35:21,659 INFO  [async-dispatch-3] [p.t.s.w.jetty9-service] Shutting down web server(s).
2018-01-18 14:35:21,664 INFO  [async-dispatch-3] [p.t.s.w.jetty9-core] Shutting down web server.
2018-01-18 14:35:21,678 INFO  [async-dispatch-3] [o.e.j.s.ServerConnector] Stopped ServerConnector@31e91a5e{SSL-HTTP/1.1}{0.0.0.0:8170}
2018-01-18 14:35:21,680 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@3cb09fd4{/code-manager/v1,null,UNAVAILABLE}
2018-01-18 14:35:21,689 INFO  [async-dispatch-3] [p.t.s.w.jetty9-core] Web server shutdown
2018-01-18 14:35:21,690 INFO  [async-dispatch-3] [p.t.s.w.jetty9-core] Shutting down web server.
2018-01-18 14:35:21,691 INFO  [async-dispatch-3] [o.e.j.s.ServerConnector] Stopped ServerConnector@2f656e28{SSL-HTTP/1.1}{0.0.0.0:8140}
2018-01-18 14:35:21,691 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@7d6e1bdb{/file-sync,null,UNAVAILABLE}
2018-01-18 14:35:21,691 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@2d6d611e{/status,null,UNAVAILABLE}
2018-01-18 14:35:21,703 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.ServletContextHandler@143d43f3{/metrics/v2,null,UNAVAILABLE}
2018-01-18 14:35:21,703 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@750b64df{/metrics,null,UNAVAILABLE}
2018-01-18 14:35:21,703 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@6fa17ae8{/,null,UNAVAILABLE}
2018-01-18 14:35:21,703 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@38b36cfd{/puppet,null,UNAVAILABLE}
2018-01-18 14:35:21,703 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@6660e6f3{/puppet-admin-api,null,UNAVAILABLE}
2018-01-18 14:35:21,703 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.h.ContextHandler@67afb3f0{/puppet-ca,null,UNAVAILABLE}
2018-01-18 14:35:21,705 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.ServletContextHandler@449343c9{/file-sync-git,null,UNAVAILABLE}
2018-01-18 14:35:21,707 INFO  [async-dispatch-3] [o.e.j.s.h.ContextHandler] Stopped o.e.j.s.ServletContextHandler@d318ff1{/packages,file:/opt/puppetlabs/server/data/packages/public/,UNAVAILABLE}
2018-01-18 14:35:21,714 INFO  [async-dispatch-3] [p.t.s.w.jetty9-core] Web server shutdown
2018-01-18 14:35:21,735 INFO  [Thread-2] [p.t.internal] Finished shutdown sequence
2018-01-18 14:35:37,404 INFO  [main] [o.e.j.u.log] Logging initialized @14603ms
2018-01-18 14:35:44,840 INFO  [async-dispatch-2] [p.t.s.w.jetty9-service] Initializing web server(s).
2018-01-18 14:35:44,985 INFO  [async-dispatch-2] [p.e.s.f.file-sync-storage-core] Initializing file sync server data dir: /opt/puppetlabs/server/data/puppetserver/filesync/storage
2018-01-18 14:35:44,990 INFO  [async-dispatch-2] [p.e.s.f.file-sync-storage-core] Initializing Git repository at /opt/puppetlabs/server/data/puppetserver/filesync/storage/puppet-code.git
2018-01-18 14:35:45,169 INFO  [async-dispatch-2] [p.e.s.f.file-sync-storage-service] File sync storage service mounting repositories at /file-sync-git
2018-01-18 14:35:45,278 INFO  [async-dispatch-2] [p.e.s.f.file-sync-storage-service] Registering file sync storage HTTP API
2018-01-18 14:35:45,280 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status callback function for service 'file-sync-storage-service', version 2017.2.0.6
2018-01-18 14:35:45,286 INFO  [async-dispatch-2] [p.c.services] Starting code-manager v1 API...
2018-01-18 14:35:45,290 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status callback function for service 'code-manager-service', version 2017.2.0.6
2018-01-18 14:35:45,309 INFO  [async-dispatch-2] [p.e.s.f.file-sync-storage-service] Adding a client status channel :code-manager with buffer size 1000
2018-01-18 14:35:45,310 INFO  [async-dispatch-2] [p.c.core] Client status event loop initialized...
2018-01-18 14:35:45,365 INFO  [async-dispatch-2] [p.c.config] Writing r10k config to "/opt/puppetlabs/server/data/code-manager/r10k.yaml"
2018-01-18 14:35:45,383 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status callback function for service 'pe-puppet-profiler', version 2017.2.0.8
2018-01-18 14:35:45,385 INFO  [async-dispatch-2] [p.s.j.jruby-puppet-service] Initializing the JRuby service
2018-01-18 14:35:45,398 INFO  [async-dispatch-2] [p.s.j.jruby-pool-manager-service] Initializing the JRuby service
2018-01-18 14:35:45,424 INFO  [clojure-agent-send-pool-0] [p.s.j.i.jruby-internal] Creating JRubyInstance with id 1.
2018-01-18 14:35:51,818 WARN  [clojure-agent-send-pool-0] [puppetserver] Puppet Support for ruby version 1.9.3 is deprecated and will be removed in a future release. See https://docs.puppet.com/puppet/latest/system_requirements.html#ruby for a list of supported ruby versions.
   (at /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet.rb:180:in `Puppet')
2018-01-18 14:35:51,860 INFO  [clojure-agent-send-pool-0] [puppetserver] Puppet Puppet settings initialized; run mode: master
2018-01-18 14:35:52,443 INFO  [clojure-agent-send-pool-0] [p.s.j.i.jruby-agents] Finished creating JRubyInstance 1 of 2
2018-01-18 14:35:52,443 INFO  [clojure-agent-send-pool-0] [p.s.j.i.jruby-internal] Creating JRubyInstance with id 2.
2018-01-18 14:35:52,470 INFO  [async-dispatch-2] [p.s.c.puppet-server-config-core] Not overriding webserver settings with values from core Puppet
2018-01-18 14:35:52,494 INFO  [async-dispatch-2] [p.p.certificate-authority] CA already initialized for SSL
2018-01-18 14:35:52,503 INFO  [async-dispatch-2] [p.s.c.certificate-authority-service] CA Service adding a ring handler
2018-01-18 14:35:52,540 INFO  [async-dispatch-2] [p.s.p.puppet-admin-service] Starting Puppet Admin web app
2018-01-18 14:35:52,554 INFO  [async-dispatch-2] [p.e.s.f.file-sync-client-service] Initializing file sync client service
2018-01-18 14:35:52,565 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status callback function for service 'file-sync-client-service', version 2017.2.0.6
2018-01-18 14:35:52,568 INFO  [async-dispatch-2] [p.e.s.f.file-sync-client-service] Registering file sync client HTTP API
2018-01-18 14:35:55,617 WARN  [clojure-agent-send-pool-0] [puppetserver] Puppet Support for ruby version 1.9.3 is deprecated and will be removed in a future release. See https://docs.puppet.com/puppet/latest/system_requirements.html#ruby for a list of supported ruby versions.
   (at /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet.rb:180:in `Puppet')
2018-01-18 14:35:55,644 INFO  [clojure-agent-send-pool-0] [puppetserver] Puppet Puppet settings initialized; run mode: master
2018-01-18 14:35:55,997 INFO  [clojure-agent-send-pool-0] [p.s.j.i.jruby-agents] Finished creating JRubyInstance 2 of 2
2018-01-18 14:35:58,957 WARN  [async-dispatch-2] [p.e.s.f.file-sync-client-core] Repo ':puppet-code' at commit '5716919b9b0c035553fcbedaaa5a4e8aad4e39c6' is dirty. Detailed repo status follows.
{:clean false,
 :modified [],
 :missing [],
 :untracked [],
 :permissions-modified [],
 :dirty-submodules
 {:simp_dev
  {:modified
   ("src/puppet/modules/logstash/spec/fixtures/modules/logstash/templates"),
   :clean false,
   :permissions-modified [],
   :untracked (),
   :missing ()}}}

2018-01-18 14:35:58,962 INFO  [async-dispatch-2] [p.e.s.f.file-sync-versioned-code-service] Registering the following pre-commit-hook-command for the :puppet-code repo: '/opt/puppetlabs/server/bin/generate-puppet-types.rb'
2018-01-18 14:35:58,964 INFO  [async-dispatch-2] [p.e.s.f.file-sync-storage-service] Adding pre-commit-hook to :puppet-code repo
2018-01-18 14:35:58,984 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status callback function for service 'pe-jruby-metrics', version 2017.2.0.8
2018-01-18 14:35:59,089 INFO  [async-dispatch-2] [p.p.certificate-authority] Master already initialized for SSL
2018-01-18 14:35:59,089 INFO  [async-dispatch-2] [p.e.s.m.master-service] Master Service adding a ring handler
2018-01-18 14:35:59,090 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status callback function for service 'pe-master', version 2017.2.0.8
2018-01-18 14:35:59,117 WARN  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Empty contextPath
2018-01-18 14:35:59,127 INFO  [async-dispatch-2] [p.t.s.w.jetty9-service] Starting web server(s).
2018-01-18 14:35:59,209 INFO  [async-dispatch-2] [p.t.s.w.jetty9-core] Starting web server.
2018-01-18 14:35:59,212 INFO  [async-dispatch-2] [o.e.j.s.Server] jetty-9.2.z-SNAPSHOT
2018-01-18 14:35:59,253 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@562bd6bd{/code-manager/v1,null,AVAILABLE}
2018-01-18 14:35:59,294 INFO  [async-dispatch-2] [o.e.j.s.ServerConnector] Started ServerConnector@48ec8aa9{SSL-HTTP/1.1}{0.0.0.0:8170}
2018-01-18 14:35:59,295 INFO  [async-dispatch-2] [o.e.j.s.Server] Started @36496ms
2018-01-18 14:35:59,303 INFO  [async-dispatch-2] [p.t.s.w.jetty9-core] Starting web server.
2018-01-18 14:35:59,303 INFO  [async-dispatch-2] [o.e.j.s.Server] jetty-9.2.z-SNAPSHOT
2018-01-18 14:35:59,345 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.ServletContextHandler@420498de{/packages,file:/opt/puppetlabs/server/data/packages/public/,AVAILABLE}
2018-01-18 14:35:59,367 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.ServletContextHandler@5b892e54{/file-sync-git,null,AVAILABLE}
2018-01-18 14:35:59,367 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@4d642c24{/puppet-ca,null,AVAILABLE}
2018-01-18 14:35:59,368 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@2bc08f3e{/puppet-admin-api,null,AVAILABLE}
2018-01-18 14:35:59,368 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@39a9ff9c{/puppet,null,AVAILABLE}
2018-01-18 14:35:59,368 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@614e3da2{/,null,AVAILABLE}
2018-01-18 14:35:59,368 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@d2728a3{/metrics,null,AVAILABLE}
2018-01-18 14:35:59,397 INFO  [async-dispatch-2] [p.t.s.m.jolokia] Using policy access restrictor classpath:/jolokia-access.xml
2018-01-18 14:35:59,455 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.ServletContextHandler@22b1ff46{/metrics/v2,null,AVAILABLE}
2018-01-18 14:35:59,460 INFO  [async-dispatch-2] [o.e.j.s.ServerConnector] Started ServerConnector@3a52e14{SSL-HTTP/1.1}{0.0.0.0:8140}
2018-01-18 14:35:59,460 INFO  [async-dispatch-2] [o.e.j.s.Server] Started @36662ms
2018-01-18 14:35:59,465 INFO  [async-dispatch-2] [p.t.s.s.status-core] Starting background monitoring of cpu usage metrics
2018-01-18 14:35:59,471 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status callback function for service 'status-service', version 0.7.1
2018-01-18 14:35:59,472 INFO  [async-dispatch-2] [p.t.s.s.status-service] Registering status service HTTP API at /status
2018-01-18 14:35:59,487 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@793ebf52{/status,null,AVAILABLE}
2018-01-18 14:35:59,489 INFO  [async-dispatch-2] [p.e.s.f.file-sync-web-service] Registering file sync HTTP API at /file-sync
2018-01-18 14:35:59,492 INFO  [async-dispatch-2] [o.e.j.s.h.ContextHandler] Started o.e.j.s.h.ContextHandler@46d0c2f9{/file-sync,null,AVAILABLE}
2018-01-18 14:35:59,515 INFO  [async-dispatch-2] [p.e.s.a.analytics-service] Puppet Server Analytics has successfully started and will run in the background
2018-01-18 14:35:59,519 INFO  [async-dispatch-2] [p.e.s.f.file-sync-client-service] Starting file sync client service
2018-01-18 14:35:59,617 INFO  [async-dispatch-2] [p.e.s.m.master-service] Puppet Server has successfully started and is now ready to handle requests
2018-01-18 14:35:59,619 INFO  [async-dispatch-2] [p.e.s.l.pe-legacy-routes-service] The legacy routing service has successfully started and is now ready to handle requests
2018-01-18 14:36:00,159 INFO  [pool-4-thread-3] [p.d.version-check] Newer version 2017.3.2 is available! Visit http://links.puppet.com/enterpriseupgrade for details.
2018-01-18 14:36:47,017 INFO  [qtp458452311-86] [puppetserver] Puppet Caching node for puppet-agent-01.hsd1.mi.comcast.net
2018-01-18 14:36:47,246 INFO  [qtp458452311-82] [puppetserver] mount[pe_packages] allowing * access
2018-01-18 14:36:47,246 INFO  [qtp458452311-82] [puppetserver] mount[pe_modules] allowing * access
2018-01-18 14:36:53,048 INFO  [qtp458452311-83] [puppetserver] Puppet 'replace_facts' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID 3d973a97-9c16-4c7e-add3-d2999c3a7581
2018-01-18 14:36:53,321 INFO  [qtp458452311-83] [puppetserver] Puppet Caching node for puppet-agent-01.hsd1.mi.comcast.net
2018-01-18 14:36:53,761 WARN  [qtp458452311-83] [puppetserver] Puppet /etc/puppetlabs/puppet/hiera.yaml: Use of 'hiera.yaml' version 3 is deprecated. It should be converted to version 5
   (in /etc/puppetlabs/puppet/hiera.yaml)
2018-01-18 14:36:53,767 WARN  [qtp458452311-83] [puppetserver] Puppet hiera.yaml version 3 found at the environment root was ignored
   (in /etc/puppetlabs/code/environments/simp_dev/hiera.yaml)
2018-01-18 14:36:53,977 WARN  [qtp458452311-83] [c.p.p.ShellUtils] Executed an external process which logged to STDERR: RPM version 4.11.3

2018-01-18 14:36:54,014 WARN  [qtp458452311-83] [c.p.p.ShellUtils] Executed an external process which logged to STDERR: /bin/rpm
/etc/rpm
/usr/bin/rpm2cpio
/usr/bin/rpmdb
/usr/bin/rpmkeys
/usr/bin/rpmquery
/usr/bin/rpmverify
/usr/lib/rpm
/usr/lib/rpm/macros
/usr/lib/rpm/macros.d
/usr/lib/rpm/platform
/usr/lib/rpm/platform/aarch64-linux
/usr/lib/rpm/platform/aarch64-linux/macros
/usr/lib/rpm/platform/alpha-linux
/usr/lib/rpm/platform/alpha-linux/macros
/usr/lib/rpm/platform/alphaev5-linux
/usr/lib/rpm/platform/alphaev5-linux/macros
/usr/lib/rpm/platform/alphaev56-linux
/usr/lib/rpm/platform/alphaev56-linux/macros
/usr/lib/rpm/platform/alphaev6-linux
/usr/lib/rpm/platform/alphaev6-linux/macros
/usr/lib/rpm/platform/alphaev67-linux
/usr/lib/rpm/platform/alphaev67-linux/macros
/usr/lib/rpm/platform/alphapca56-linux
/usr/lib/rpm/platform/alphapca56-linux/macros
/usr/lib/rpm/platform/amd64-linux
/usr/lib/rpm/platform/amd64-linux/macros
/usr/lib/rpm/platform/armv3l-linux
/usr/lib/rpm/platform/armv3l-linux/macros
/usr/lib/rpm/platform/armv4b-linux
/usr/lib/rpm/platform/armv4b-linux/macros
/usr/lib/rpm/platform/armv4l-linux
/usr/lib/rpm/platform/armv4l-linux/macros
/usr/lib/rpm/platform/armv5tejl-linux
/usr/lib/rpm/platform/armv5tejl-linux/macros
/usr/lib/rpm/platform/armv5tel-linux
/usr/lib/rpm/platform/armv5tel-linux/macros
/usr/lib/rpm/platform/armv6l-linux
/usr/lib/rpm/platform/armv6l-linux/macros
/usr/lib/rpm/platform/armv7hl-linux
/usr/lib/rpm/platform/armv7hl-linux/macros
/usr/lib/rpm/platform/armv7hnl-linux
/usr/lib/rpm/platform/armv7hnl-linux/macros
/usr/lib/rpm/platform/armv7l-linux
/usr/lib/rpm/platform/armv7l-linux/macros
/usr/lib/rpm/platform/athlon-linux
/usr/lib/rpm/platform/athlon-linux/macros
/usr/lib/rpm/platform/geode-linux
/usr/lib/rpm/platform/geode-linux/macros
/usr/lib/rpm/platform/i386-linux
/usr/lib/rpm/platform/i386-linux/macros
/usr/lib/rpm/platform/i486-linux
/usr/lib/rpm/platform/i486-linux/macros
/usr/lib/rpm/platform/i586-linux
/usr/lib/rpm/platform/i586-linux/macros
/usr/lib/rpm/platform/i686-linux
/usr/lib/rpm/platform/i686-linux/macros
/usr/lib/rpm/platform/ia32e-linux
/usr/lib/rpm/platform/ia32e-linux/macros
/usr/lib/rpm/platform/ia64-linux
/usr/lib/rpm/platform/ia64-linux/macros
/usr/lib/rpm/platform/m68k-linux
/usr/lib/rpm/platform/m68k-linux/macros
/usr/lib/rpm/platform/noarch-linux
/usr/lib/rpm/platform/noarch-linux/macros
/usr/lib/rpm/platform/pentium3-linux
/usr/lib/rpm/platform/pentium3-linux/macros
/usr/lib/rpm/platform/pentium4-linux
/usr/lib/rpm/platform/pentium4-linux/macros
/usr/lib/rpm/platform/ppc-linux
/usr/lib/rpm/platform/ppc-linux/macros
/usr/lib/rpm/platform/ppc32dy4-linux
/usr/lib/rpm/platform/ppc32dy4-linux/macros
/usr/lib/rpm/platform/ppc64-linux
/usr/lib/rpm/platform/ppc64-linux/macros
/usr/lib/rpm/platform/ppc64iseries-linux
/usr/lib/rpm/platform/ppc64iseries-linux/macros
/usr/lib/rpm/platform/ppc64le-linux
/usr/lib/rpm/platform/ppc64le-linux/macros
/usr/lib/rpm/platform/ppc64p7-linux
/usr/lib/rpm/platform/ppc64p7-linux/macros
/usr/lib/rpm/platform/ppc64pseries-linux
/usr/lib/rpm/platform/ppc64pseries-linux/macros
/usr/lib/rpm/platform/ppc8260-linux
/usr/lib/rpm/platform/ppc8260-linux/macros
/usr/lib/rpm/platform/ppc8560-linux
/usr/lib/rpm/platform/ppc8560-linux/macros
/usr/lib/rpm/platform/ppciseries-linux
/usr/lib/rpm/platform/ppciseries-linux/macros
/usr/lib/rpm/platform/ppcpseries-linux
/usr/lib/rpm/platform/ppcpseries-linux/macros
/usr/lib/rpm/platform/s390-linux
/usr/lib/rpm/platform/s390-linux/macros
/usr/lib/rpm/platform/s390x-linux
/usr/lib/rpm/platform/s390x-linux/macros
/usr/lib/rpm/platform/sh-linux
/usr/lib/rpm/platform/sh-linux/macros
/usr/lib/rpm/platform/sh3-linux
/usr/lib/rpm/platform/sh3-linux/macros
/usr/lib/rpm/platform/sh4-linux
/usr/lib/rpm/platform/sh4-linux/macros
/usr/lib/rpm/platform/sh4a-linux
/usr/lib/rpm/platform/sh4a-linux/macros
/usr/lib/rpm/platform/sparc-linux
/usr/lib/rpm/platform/sparc-linux/macros
/usr/lib/rpm/platform/sparc64-linux
/usr/lib/rpm/platform/sparc64-linux/macros
/usr/lib/rpm/platform/sparc64v-linux
/usr/lib/rpm/platform/sparc64v-linux/macros
/usr/lib/rpm/platform/sparcv8-linux
/usr/lib/rpm/platform/sparcv8-linux/macros
/usr/lib/rpm/platform/sparcv9-linux
/usr/lib/rpm/platform/sparcv9-linux/macros
/usr/lib/rpm/platform/sparcv9v-linux
/usr/lib/rpm/platform/sparcv9v-linux/macros
/usr/lib/rpm/platform/x86_64-linux
/usr/lib/rpm/platform/x86_64-linux/macros
/usr/lib/rpm/rpm.daily
/usr/lib/rpm/rpm.log
/usr/lib/rpm/rpm.supp
/usr/lib/rpm/rpm2cpio.sh
/usr/lib/rpm/rpmdb_dump
/usr/lib/rpm/rpmdb_load
/usr/lib/rpm/rpmdb_loadcvt
/usr/lib/rpm/rpmdb_recover
/usr/lib/rpm/rpmdb_stat
/usr/lib/rpm/rpmdb_upgrade
/usr/lib/rpm/rpmdb_verify
/usr/lib/rpm/rpmpopt-4.11.3
/usr/lib/rpm/rpmrc
/usr/lib/rpm/tgpg
/usr/lib/tmpfiles.d/rpm.conf
/usr/share/bash-completion/completions/rpm
/usr/share/doc/rpm-4.11.3
/usr/share/doc/rpm-4.11.3/COPYING
/usr/share/doc/rpm-4.11.3/CREDITS
/usr/share/doc/rpm-4.11.3/ChangeLog.bz2
/usr/share/doc/rpm-4.11.3/GROUPS
/usr/share/doc/rpm-4.11.3/builddependencies
/usr/share/doc/rpm-4.11.3/buildroot
/usr/share/doc/rpm-4.11.3/conditionalbuilds
/usr/share/doc/rpm-4.11.3/dependencies
/usr/share/doc/rpm-4.11.3/format
/usr/share/doc/rpm-4.11.3/hregions
/usr/share/doc/rpm-4.11.3/macros
/usr/share/doc/rpm-4.11.3/multiplebuilds
/usr/share/doc/rpm-4.11.3/queryformat
/usr/share/doc/rpm-4.11.3/relocatable
/usr/share/doc/rpm-4.11.3/signatures
/usr/share/doc/rpm-4.11.3/spec
/usr/share/doc/rpm-4.11.3/triggers
/usr/share/doc/rpm-4.11.3/tsort
/usr/share/locale/br/LC_MESSAGES/rpm.mo
/usr/share/locale/ca/LC_MESSAGES/rpm.mo
/usr/share/locale/cs/LC_MESSAGES/rpm.mo
/usr/share/locale/da/LC_MESSAGES/rpm.mo
/usr/share/locale/de/LC_MESSAGES/rpm.mo
/usr/share/locale/el/LC_MESSAGES/rpm.mo
/usr/share/locale/eo/LC_MESSAGES/rpm.mo
/usr/share/locale/es/LC_MESSAGES/rpm.mo
/usr/share/locale/fi/LC_MESSAGES/rpm.mo
/usr/share/locale/fr/LC_MESSAGES/rpm.mo
/usr/share/locale/is/LC_MESSAGES/rpm.mo
/usr/share/locale/it/LC_MESSAGES/rpm.mo
/usr/share/locale/ja/LC_MESSAGES/rpm.mo
/usr/share/locale/ko/LC_MESSAGES/rpm.mo
/usr/share/locale/ms/LC_MESSAGES/rpm.mo
/usr/share/locale/nb/LC_MESSAGES/rpm.mo
/usr/share/locale/nl/LC_MESSAGES/rpm.mo
/usr/share/locale/pl/LC_MESSAGES/rpm.mo
/usr/share/locale/pt/LC_MESSAGES/rpm.mo
/usr/share/locale/pt_BR/LC_MESSAGES/rpm.mo
/usr/share/locale/ru/LC_MESSAGES/rpm.mo
/usr/share/locale/sk/LC_MESSAGES/rpm.mo
/usr/share/locale/sl/LC_MESSAGES/rpm.mo
/usr/share/locale/sr/LC_MESSAGES/rpm.mo
/usr/share/locale/sr@latin/LC_MESSAGES/rpm.mo
/usr/share/locale/sv/LC_MESSAGES/rpm.mo
/usr/share/locale/te/LC_MESSAGES/rpm.mo
/usr/share/locale/tr/LC_MESSAGES/rpm.mo
/usr/share/locale/uk/LC_MESSAGES/rpm.mo
/usr/share/locale/zh_CN/LC_MESSAGES/rpm.mo
/usr/share/locale/zh_TW/LC_MESSAGES/rpm.mo
/usr/share/man/fr/man8/rpm.8.gz
/usr/share/man/ja/man8/rpm.8.gz
/usr/share/man/ja/man8/rpm2cpio.8.gz
/usr/share/man/ja/man8/rpmbuild.8.gz
/usr/share/man/ja/man8/rpmgraph.8.gz
/usr/share/man/ko/man8/rpm.8.gz
/usr/share/man/ko/man8/rpm2cpio.8.gz
/usr/share/man/man8/rpm-plugin-systemd-inhibit.8.gz
/usr/share/man/man8/rpm.8.gz
/usr/share/man/man8/rpm2cpio.8.gz
/usr/share/man/man8/rpmdb.8.gz
/usr/share/man/man8/rpmkeys.8.gz
/usr/share/man/pl/man1/gendiff.1.gz
/usr/share/man/pl/man8/rpm.8.gz
/usr/share/man/pl/man8/rpm2cpio.8.gz
/usr/share/man/pl/man8/rpmbuild.8.gz
/usr/share/man/pl/man8/rpmdeps.8.gz
/usr/share/man/pl/man8/rpmgraph.8.gz
/usr/share/man/ru/man8/rpm.8.gz
/usr/share/man/ru/man8/rpm2cpio.8.gz
/usr/share/man/sk/man8/rpm.8.gz
/var/lib/rpm
/var/lib/rpm/Basenames
/var/lib/rpm/Conflictname
/var/lib/rpm/Dirnames
/var/lib/rpm/Group
/var/lib/rpm/Installtid
/var/lib/rpm/Name
/var/lib/rpm/Obsoletename
/var/lib/rpm/Packages
/var/lib/rpm/Providename
/var/lib/rpm/Requirename
/var/lib/rpm/Sha1header
/var/lib/rpm/Sigmd5
/var/lib/rpm/Triggername

2018-01-18 14:36:54,039 WARN  [qtp458452311-83] [c.p.p.ShellUtils] Executed an external process which logged to STDERR: RPM version 4.11.3

2018-01-18 14:36:54,049 WARN  [qtp458452311-83] [c.p.p.ShellUtils] Executed an external process which logged to STDERR: RPM version 4.11.3

2018-01-18 14:36:54,162 WARN  [qtp458452311-83] [c.p.p.ShellUtils] Executed an external process which logged to STDERR: RPM version 4.11.3

2018-01-18 14:36:55,191 INFO  [qtp458452311-83] [puppetserver] Puppet Inlined resource metadata into static catalog for puppet-agent-01.hsd1.mi.comcast.net in environment simp_dev in 0.02 seconds
2018-01-18 14:36:55,191 INFO  [qtp458452311-83] [puppetserver] Puppet Compiled static catalog for puppet-agent-01.hsd1.mi.comcast.net in environment simp_dev in 1.81 seconds
2018-01-18 14:36:55,191 INFO  [qtp458452311-83] [puppetserver] Puppet Caching catalog for puppet-agent-01.hsd1.mi.comcast.net
2018-01-18 14:36:55,386 INFO  [qtp458452311-83] [puppetserver] Puppet 'replace_catalog' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID ba90362c-0d93-4cb2-a6f7-b9c79d083b83
2018-01-18 14:36:58,056 INFO  [qtp458452311-82] [puppetserver] Puppet 'store_report' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID 68b203f2-d4ce-4fe3-b6ac-85730e14a074
2018-01-18 14:37:12,378 INFO  [qtp458452311-85] [puppetserver] Puppet Caching node for puppet
2018-01-18 14:37:12,577 INFO  [qtp458452311-87] [puppetserver] mount[pe_packages] allowing * access
2018-01-18 14:37:12,578 INFO  [qtp458452311-87] [puppetserver] mount[pe_modules] allowing * access
2018-01-18 14:37:17,154 INFO  [qtp458452311-83] [puppetserver] Puppet Caching node for puppet-agent-01.hsd1.mi.comcast.net
2018-01-18 14:37:23,461 INFO  [qtp458452311-83] [puppetserver] Puppet 'replace_facts' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID 2f35fd2f-760a-48b9-9260-e2229f3bacdf
2018-01-18 14:37:23,763 INFO  [qtp458452311-83] [puppetserver] Puppet Caching node for puppet-agent-01.hsd1.mi.comcast.net
2018-01-18 14:37:24,681 INFO  [qtp458452311-83] [puppetserver] Puppet Inlined resource metadata into static catalog for puppet-agent-01.hsd1.mi.comcast.net in environment simp_dev in 0.02 seconds
2018-01-18 14:37:24,681 INFO  [qtp458452311-83] [puppetserver] Puppet Compiled static catalog for puppet-agent-01.hsd1.mi.comcast.net in environment simp_dev in 0.87 seconds
2018-01-18 14:37:24,682 INFO  [qtp458452311-83] [puppetserver] Puppet Caching catalog for puppet-agent-01.hsd1.mi.comcast.net
2018-01-18 14:37:24,860 INFO  [qtp458452311-83] [puppetserver] Puppet 'replace_catalog' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID 17c61fa9-4701-42de-b932-cd1ba66ceabb
2018-01-18 14:37:26,718 INFO  [qtp458452311-82] [puppetserver] Puppet 'store_report' command for puppet-agent-01.hsd1.mi.comcast.net submitted to PuppetDB with UUID f38680ed-26f0-4935-9839-a06b46bd9c11
2018-01-18 14:38:32,087 INFO  [qtp458452311-82] [puppetserver] Puppet 'replace_facts' command for puppet submitted to PuppetDB with UUID 76c9ce4e-1354-450f-83e8-3c6f061b0d13
2018-01-18 14:38:32,294 INFO  [qtp458452311-82] [puppetserver] Puppet Caching node for puppet
2018-01-18 14:38:37,650 INFO  [qtp458452311-82] [puppetserver] Puppet Inlined resource metadata into static catalog for puppet in environment production in 0.02 seconds
2018-01-18 14:38:37,651 INFO  [qtp458452311-82] [puppetserver] Puppet Compiled static catalog for puppet in environment production in 5.32 seconds
2018-01-18 14:38:37,651 INFO  [qtp458452311-82] [puppetserver] Puppet Caching catalog for puppet
2018-01-18 14:38:38,076 INFO  [qtp458452311-82] [puppetserver] Puppet 'replace_catalog' command for puppet submitted to PuppetDB with UUID c23c7e3b-6238-4f90-b737-3fd648fa05e4
2018-01-18 14:38:55,032 INFO  [qtp458452311-85] [puppetserver] Puppet 'store_report' command for puppet submitted to PuppetDB with UUID bc56cb00-1358-4fac-9289-922a58f989b3
[root@puppet manifests]#




http://simp.readthedocs.io/en/6.1.0-0/user_guide/SIMP_Administration/Classification_and_Data.html#node-classification-in-simp


puppet-agent-01.hsd1.mi.comcast.net



Added code to site.pp (found in control-repo_simp)

site.pp

# Set the global Exec path to something reasonable
Exec {
  path => [
    '/usr/local/bin',
    '/usr/local/sbin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin'
  ]
}

# SIMP Scenarios
#
# Set this variable to make use of the different class sets in heiradata/scenarios,
#   mostly applicable to puppet agents, or, the SIMP server overrides some of these.
#   * `simp` - compliant and secure
#   * `simp-lite` - makes use of many of our modules, but doesn't apply
#        many prohibitive security or compliance features, svckill
#   * `poss` - only include pupmod by default to configure the agent
$simp_scenario = 'simp'

# Map SIMP parameters to NIST Special Publication 800-53, Revision 4
# See hieradata/compliance_profiles/ for more options.
$compliance_profile = 'nist_800_53_rev4'

# Place Hiera customizations based on this variable in hieradata/hostgroups/${::hostgroup}.yaml
#
# Example hostgroup declaration using a regex match on the hostname:
#   if $facts['fqdn'] =~ /ws\d+\.<domain>/ {
#     $hostgroup = 'workstations'
#   }
#   else {
#     $hostgroup = 'default'
#   }
#
$hostgroup = 'default'

# Required if you want the SIMP global catalysts
# Defaults should technically be sane in all modules without this
include 'simp_options'
# Include the SIMP base controller with the preferred scenario
include 'simp'

# Hiera class lookups and inclusions (replaces `hiera_include()`)
$hiera_classes          = lookup('classes',          Array[String], 'unique', [])
$hiera_class_exclusions = lookup('class_exclusions', Array[String], 'unique', [])
$hiera_included_classes = $hiera_classes - $hiera_class_exclusions

include $hiera_included_classes

# For proper functionality, the compliance_markup list needs to be included *absolutely last*
include compliance_markup

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx




Start with a one- or two-sentence summary of what the module does and/or what
problem it solves. This is your 30-second elevator pitch for your module.
Consider including OS/Puppet version it works with.

You can give more descriptive information in a second paragraph. This paragraph
should answer the questions: "What does this module *do*?" and "Why would I use
it?" If your module has a range of functionality (installation, configuration,
management, etc.), this is the time to mention it.

## Setup

### What gitver affects **OPTIONAL**

If it's obvious what your module touches, you can skip this section. For
example, folks can probably figure out that your mysql_instance module affects
their MySQL instances.

If there's more that they should know about, though, this is the place to mention:

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute.
* Dependencies that your module automatically installs.
* Warnings or other important notices.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you might want to include an additional "Upgrading" section
here.

### Beginning with gitver

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module.

## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

Users need a complete list of your module's classes, types, defined types providers, facts, and functions, along with the parameters for each. You can provide this list either via Puppet Strings code comments or as a complete list in this Reference section.

* If you are using Puppet Strings code comments, this Reference section should include Strings information so that your users know how to access your documentation.

* If you are not using Puppet Strings, include a list of all of your classes, defined types, and so on, along with their parameters. Each element in this listing should include:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
