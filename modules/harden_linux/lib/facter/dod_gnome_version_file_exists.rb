# dod_gnome_version_file.rb
# V-71849
# To see a custom fact, run "puppet facts" or "facter -p <fact_name>"

# GNOME 3 version is stored in this file:
#
# /usr/share/gnome/gnome-version.xml
#
# content (on my system):
#
#<?xml version="1.0" encoding="UTF-8"?>
#<gnome-version>
# <platform>3</platform>
# <minor>6</minor>
# <micro>2</micro>
# <distributor>Arch Linux</distributor>
# <date>2012-11-13</date>
#</gnome-version>
#
# The file is part of the upstream package called gnome-desktop
# (note that some distros split it into several packages so on your distro
# the file may end up in a package with a different name.)
# GNOME developers use this file to get the DE version number and display it in
# System Settings (aka gnome-control-center).
# So getting GNOME version "the official way" means parsing the said file
# and extracting platform, minor and micro values.
# If you play with that file you can instantly see the results :)
#
# Source: https://unix.stackexchange.com/questions/73212/how-to-get-the-gnome-version


Facter.add('dod_gnome_version_file_exists') do
  confine :kernel => 'Linux'
  setcode do
    File.exist?('/usr/share/gnome/gnome-version.xml') || File.symlink?('/usr/share/gnome/gnome-version.xml')
  end
end
