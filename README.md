# node_pm2

[![Build Status](https://travis-ci.org/teknofire/pm2-cookbook.svg?branch=master)](https://travis-ci.org/teknofire/pm2-cookbook)

Adding some basic handling for using PM2 to manage nodejs services

## Requirements

## platforms

* Ubuntu 14.04+
* Centos 6+

## chef

* Chef 12.1+

## usage

Add cookbook to `metadata.rb`

```ruby
depends 'node_pm2'
```

Then in cookbook recipe add

```ruby
# only needed if you don't already have nodejs, npm and pm2 installed
include_recipe 'node_pm2::default'

pm2_service 'test' do
  config script: 'test.js', cwd: '/opt/test'
  action [:create, :enable, :start]
end
```

## recipes

### default

Installs nodejs, npm and pm2.  If you already have these dependencies in place then you do not need to include the recipe

## resources

### pm2_service

Used to setup and control any nodejs services using pm2

#### actions

* :create
* :enable
* :start
* :stop
* :reload
* :restart
* :start_or_restart
* :start_or_reload
