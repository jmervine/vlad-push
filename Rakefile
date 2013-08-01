# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'vlad-push' do
  developer('Joshua P. Mervine', 'joshua@mervine.net')
  license('MIT')
  extra_deps << ['vlad', '~> 2.0']
end

begin 
  require 'vlad'
  Vlad.load :scm => :push
rescue LoadError
  # do nothing
end

# vim: syntax=ruby
