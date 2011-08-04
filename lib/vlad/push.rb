require 'vlad'

# @author Joshua P. Mervine <jmervine@mervine.net> 
#
# Please see {file:lib/vlad/push.rb Vlad::Push Source} for Rake task documentation.
class Vlad::Push
  VERSION = "1.0.2"

  # @attribute[rw] 
  # init Vlad::Push
  set :source, Vlad::Push.new

  # @attribute[rw] 
  # set default repository
  set :repository,      "/tmp/repo"
  
  # @attribute[rw] 
  # set default scm
  set :scm,             :push

  # @attribute[rw] 
  # set default scp command
  set :push_scp, "scp"
  
  # @attribute[rw] 
  # set default ssh/scp flags as none
  set :ssh_flags, ""
  
  # @attribute[rw] 
  # allow for overwriting release_name via command line
  set :release_name, ENV['RELEASE']||release_name

  # Overwriting Vlad.checkout, to do nothing.
  #
  # @return [String] echo bash command
  #
  # @param revision [String] ignored
  # @param destination [String] ignored
  def checkout(revision, destination)
    "echo '[vlad-push] skipping checkout, not needed without scm'"
  end

  # Overwrite Vlad.export to simply copied what was
  # pushed from the 'repository' location to the 
  # 'destination'
  #
  # @param source [String] ignored
  # @param destination [String] target export folder
  def export(source, destination)
    "cp -r #{repository} #{destination}"
  end

  # Overwriting Vlad.revision
  #
  # @param revision [String] ignored
  # @return [String] returning 'repository'
  def revision(revision)
    repository
  end

  # Push extracted and compressed files to 'host'
  # this should be run once for each host by
  # the rake task :push
  #
  # @param host [String] working host to push to
  # @return [String] bash command do push
  def push(host)
    [ "#{push_scp} #{ssh_flags.join(' ')}",
      "/tmp/#{application}-#{release_name}.tgz",
      "#{host}:/tmp/#{application}-#{release_name}.tgz"
    ].join(" ")
  end

  # Extract the remote compressed file on each host
  #
  # @return [String] bash command to extract compressed archive on remote server
  def push_extract
    [ "if [ -e #{repository} ]; then rm -rf #{repository}; fi",
      "mkdir -p #{repository}",
      "cd #{repository}",
      "tar -xzf /tmp/#{application}-#{release_name}.tgz"
    ].join(" && ")
  end

  # Clean up old compressed archives both locally and remotely
  #
  # @return [String] bash command to remove compressed archives
  def push_cleanup
    [ "rm -vrf /tmp/#{application}-*.tgz",
      [ "if [ -e #{repository} ]",
        "then rm -rf #{repository}",
        "fi"
      ].join("; ")
    ].join(" && ")
  end

  # Compress the files in the current working directory 
  # to be pushed to the remote server
  #
  # @return [String] bash command to compress current directory
  def compress
    [ "tar -czf /tmp/#{application}-#{release_name}.tgz",
      '--exclude "\.git*"',
      '--exclude "\.svn*"',
      "."
    ].join(" ") 
  end

  # Using :vlad namespace to make this part 
  # of vlad in rake
  namespace :vlad do

    # Run the following on specified environment:
    # * Vlad::Push.compress
    # * Vlad::Push.push
    # * Vlad::Push.push_extract
    desc "Push current working directory to remote servers."
    remote_task :push do
      sh source.compress
      # TODO: find a better way to ensure array for each
      [domain].flatten.each do |host|
        sh source.push(host)
      end
      run source.push_extract
    end

    # Updating 'vlad:cleanup' to include post-task
    remote_task :cleanup do
      Rake::Task['vlad:push_cleanup'].invoke
    end

    # Run the following on specified environment:
    # * Vlad::Push.push_cleanup on local machine
    # * Vlad::Push.push_cleanup on remote machines
    desc "Clean up archive files created by push. This will also be run by vlad:cleanup."
    remote_task :push_cleanup do
      sh source.push_cleanup
      run source.push_cleanup
    end

    # Adding task to do both 'vlad:push' and 'vlad:update' rake tasks
    desc "Runs push and update"
    task :deploy do
      Rake::Task["vlad:push"].invoke
      Rake::Task["vlad:update"].invoke
    end

  end

end 


