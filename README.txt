= vlad-push

* http://github.com/jmervine/vlad-push

== DESCRIPTION:

Adds support to Vlad for pushing files to a remote server without SCM.


== FEATURES/PROBLEMS:

* Requires vlad-git gem

== SYNOPSIS:

  $ rake <env> vlad:push
  $ rake <env> vlad:update

  or

  $ rake <env> vlad:deploy


== REQUIREMENTS:

* Vlad[http://rubyhitsquad.com/Vlad_the_Deployer.html]
* Vlad-git[https://github.com/jbarnette/vlad-git.git]

== INSTALL:

    $ sudo gem install vlad-push 

== VARIABLES:

repository::	        Vlad config param, should be set to a directory location
			to use as repo on remote server(s)
                        <tt>:repository => "/tmp/repo"</tt>
domain::	        See Vlad :domain variable
scp_cmd::          	Defaults to <tt>scp</tt>
ssh_flags::             See Vlad :ssh_flags variable

== LICENSE:

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
