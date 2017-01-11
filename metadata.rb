name 'node_pm2'
maintainer 'Will Fisher'
maintainer_email 'will@teknofire.net'
license 'Apache 2.0'
description 'Installs/Configures node_pm2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

source_url 'https://github.com/teknofire/pm2-cookbook'
issues_url 'https://github.com/teknofire/pm2-cookbook/issues'

supports 'centos'
supports 'ubuntu'

chef_version '>= 12.1'

depends 'nodejs'
