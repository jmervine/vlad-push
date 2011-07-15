# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :hg

Hoe.spec 'vlad-push' do
  self.rubyforge_name = 'jmervine'
  developer('Joshua P. Mervine', 'joshua@mervine.net')
  extra_deps << ['vlad', '~> 2.0']
  clean_globs << '.yardoc'
  self.hg_release_tag_prefix = 'rel-'
end

# vim: syntax=ruby
