# vlad-push [![Build Status](https://travis-ci.org/jmervine/vlad-push.png?brach=master)](http://travis-ci.org/jmervine/vlad-push)

* http://github.com/jmervine/vlad-push
* http://www.rubyops.net/2012/05/31/vlad-push

## DESCRIPTION:

Adds support to Vlad for pushing files to a remote server without SCM.


## FEATURES/PROBLEMS:

* Requires vlad-git gem

## SYNOPSIS:

```sh
$ rake [env] vlad:push
$ rake [env] vlad:update
         ^-- if using environment tasks in deploy.rb
```

Or

```sh
$ rake [env] vlad:deploy
         ^-- if using environment tasks in deploy.rb
```
### Rakefile sample

```ruby
require 'vlad'
Vlad.load(:scm => :push)
```

### deploy.rb sample

```ruby
set :deploy_to, "/web/root"
set :repository, "/push/root"
set :extract_dir, "/tmp/repo"
set :extract_file, "#{application}-#{release_name}.tgz"
```

## REQUIREMENTS:

* ![Vlad](http://rubyhitsquad.com/Vlad_the_Deployer.html Vlad)

## INSTALL:

```sh
    $ sudo gem install vlad-push
```

## VARIABLES:

* `repository::`
** Vlad config param, should be set to a directory location to use as repo on remote server(s) :repository => "/tmp/repo"
* `extract_file::`
** Name of tarball that vlad-push will generate, we suggest changing this
* `extract_dir::`
** Path to a directory that we will create the extract in, defaults to "/tmp"
* `domain::`
** See remote_task :domain variable
* `ssh_flags::`
** See remote_task :ssh_flags variable
* `rsync_flags::`
** See remote_task :rsync_flags variable

## ACKKNOWLEDGEMENTS:

* http://rubyhitsquad.com/ for creating Vlad.
* jbarnette for (https://github.com/jbarnette/vlad-git "vlad-git") which was used as a template for 1.0.0.
* (https://github.com/retr0h "retr0h") who turned me on to Vlad.


## LICENSE:

(The MIT License)

Copyright (c) 2011 Joshua Mervine

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
