require 'vlad'

# @author Joshua P. Mervine <jmervine@mervine.net>
#
# Please see {file:lib/vlad/push.rb Vlad::Push Source} for Rake task documentation.
class Vlad::Push
  VERSION = "1.1.1"

  # @attribute[rw]
  # init Vlad::Push
  set :source, Vlad::Push.new

  # @attribute[rw]
  # set default repository
  set :repository, "/tmp/repo"

  # @attribute[rw]
  # set default scm
  set :scm, :push

  # @attribute[rw]
  # allow for overwriting release_name via command line
  set :release_name, ENV['RELEASE']||release_name

  # @attribute[rw]
  # set default directory to build tarballs in
  set :extract_dir, "/tmp"

  # @attribute[rw]
  # set default name of tarball generates, you should override this in your rakefile
  set :extract_file, "vlad-push-extract-#{release_name}.tgz"

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

  # Extract the remote compressed file on each host
  #
  # @return [String] bash command to extract compressed archive on remote server
  def push_extract
    [ "if [ -e #{repository} ]; then rm -rf #{repository}; fi",
      "mkdir -p #{repository}",
      "cd #{repository}",
      "tar -xzf #{extract_dir}/#{extract_file}"
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
    [ "tar -czf #{extract_dir}/#{extract_file}",
      '--exclude "\.git*"',
      '--exclude "\.svn*"',
      "."
    ].join(" ")
  end

  # Using :vlad namespace to make this part
  # of vlad in rake
  namespace :vlad do

    desc "Built the extracted tarball to be pushed from the CWD"
    task :create_extract do
      sh source.compress
    end

    # Run the following on specified environment:
    # * Vlad::Push.compress
    # * Vlad::Push.push
    # * Vlad::Push.push_extract
    desc "Push current working directory to remote servers."
    remote_task :push => :create_extract do
      rsync "#{extract_dir}/#{extract_file}", "#{target_host}:#{extract_dir}/#{extract_file}"
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


