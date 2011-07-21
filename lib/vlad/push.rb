require 'vlad'
class Vlad::Push
  VERSION = "1.0.1"

  set :source, Vlad::Push.new

  # default to be overwritten by deploy.rb as needed
  set :repository,      "/tmp/repo"
  set :scm,             :push
  set :push_scp, "scp"
  set :ssh_flags, ""
  set :release_name, ENV['RELEASE']||release_name

  #@paired = false

  # telling vlad not to bother running checkout
  #  but this doesn't seem to work, I'll probably
  #  moving it to the Rakefile
  #set :skip_scm, true 

  def checkout(revision, destination)
    "echo 'skipping checkout per vlad-push'"
  end

  def export(source, destination)
    # ignoring source
    "cp -r #{repository} #{destination}"
    #[ "mkdir -p #{repository}",
      #"cd #{repository}",
      #"tar -xzf /tmp/#{application}-#{release_name}.tgz",
      #"cp -r #{repository} #{destination}"
    #].join(" && ")
  end

  def revision(revision)
  # telling vlad to use "repository" as "revision" as we have no scm
    repository
  end

  def push(host)
    [ "#{push_scp} #{ssh_flags}",
      "/tmp/#{application}-#{release_name}.tgz",
      "#{host}:/tmp/#{application}-#{release_name}.tgz"
    ].join(" ")
  end

  def push_extract
    [ "if [ -e #{repository} ]; then rm -rf #{repository}; fi",
      "mkdir -p #{repository}",
      "cd #{repository}",
      "tar -xzf /tmp/#{application}-#{release_name}.tgz"
    ].join(" && ")
  end

  def push_cleanup
    [ "rm -vrf /tmp/#{application}-*.tgz",
      [ "if [ -e #{repository} ]",
        "then rm -rf #{repository}",
        "fi"
      ].join("; ")
    ].join(" && ")
  end

  def compress
    [ "tar -czf /tmp/#{application}-#{release_name}.tgz",
      '--exclude "\.git*"',
      '--exclude "\.svn*"',
      "."
    ].join(" ") 
  end

  namespace :vlad do

    desc "Push current working directory to remote servers."
    remote_task :push do
      sh source.compress
      domain.each do |host|
        sh source.push(host)
      end
      run source.push_extract
      #if !@paired
        #puts " "
        #puts "To update successfully, execute the following command:"
        #puts " "
        #puts " $ rake <environment> vlad:update RELEASE=#{release_name}"
        #puts " "
      #end
    end

    # Updating 'vlad:cleanup' to include post-task
    remote_task :cleanup do
      Rake::Task['vlad:push_cleanup'].invoke
    end

    desc "Clean up archive files created by push. This will also be run by vlad:cleanup."
    remote_task :push_cleanup do
      sh source.push_cleanup
      run source.push_cleanup
    end

    desc "Runs push and update"
    task :deploy do
      #@paired = true
      Rake::Task["vlad:push"].invoke
      Rake::Task["vlad:update"].invoke
    end

  end

end # class def


