name             'weave'
maintainer       'Flexiant'
maintainer_email 'contact@flexiant.com'
license          'All rights reserved'
description      'Installs/Configures weave'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports "ubuntu"

depends "docker"

recipe "weave::default", "Install and configure Weave"

attribute "weave/ismaster",
  :display_name => "If host is a Master",
  :description => "If the host is Master of the weave cluster.",
  :required => "optional",
  :default => false

attribute "weave/password",
  :display_name => "Weave password",
  :description => "Password of the weave network overlay.",
  :required => "optional",
  :default => "Hello_Pepe"

attribute "weave/master_fqdn",
  :display_name => "Master FQDN of Weave Cluster",
  :description => "Master FQDN of the Weave Cluster.",
  :required => "optional"

attribute "weave/cidr",
  :display_name => "CIDR of network to construct",
  :description => "CIDR of the network to contrusct.",
  :required => "optional",
  :default => "10.2.1.1/24"
