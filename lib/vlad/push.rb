require 'vlad'

module Vlad
  module Push
    VERSION = '0.0.2' #:nodoc:
  end
end

namespace :vlad do

  set :repository,      "/tmp/repo"
  set :scm,             :git
  set :push_scp,        "scp"

  def export_cmd
    if scm.to_s == "git"
      scm_src = ".git"
    else
      raise "#{scm.to_s} not yet supported."
    end
    cmd = "tar -czf /tmp/#{application}-#{release_name}.tgz #{scm_src}"
    cmd
  end

  def push_cmd(host)
    cmd =  "#{push_scp} #{ssh_flags.join(" ")} "
    cmd << "/tmp/#{application}-#{release_name}.tgz "
    cmd << "#{host}:/tmp/#{application}-#{release_name}.tgz" 
    cmd
  end

  def extract_cmd
    cmd =  "mkdir -p #{repository} && "
    cmd << "cd #{repository} && "
    cmd << "tar -xzf /tmp/#{application}-#{release_name}.tgz"
    cmd
  end

  def cleanup_cmd
    cmd = []
    cmd << %(if [ -e /tmp/#{application}-*.tgz ])
    cmd << %(then rm -f /tmp/#{application}-*.tgz)
    cmd << %(fi)
    cmd.join("; ")
  end

  desc "Push current working directory as self contained repo on remote server repository."
  task :push do
    sh export_cmd
    domain.each do |host|
      sh push_cmd(host)
    end
    Rake::Task['vlad:after_push'].invoke
  end

  remote_task :after_push do
    puts "Extracting /tmp/#{application}-#{release_name}.tgz to #{repository}"
    run extract_cmd
  end

  # Updating 'vlad:cleanup' to include post-task
  remote_task :cleanup do
    Rake::Task['vlad:after_cleanup'].invoke
  end

  remote_task :after_cleanup do
    sh cleanup_cmd
    run cleanup_cmd
  end

end

