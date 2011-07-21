require "test/unit"
require "vlad/push"

class TestVladPush < Test::Unit::TestCase
  def setup
    super
    @source = Vlad::Push.new
    set :repository, "/tmp/repo"
    set :push_scp, "scp"
    set :ssh_flags, [ "-i", "~/.ssh/id_rsa_example" ].join(" ")
    set :application, "testapp"
    set :release_name, "12345678910"
  end

  def test_rake
    assert system("rake -T vlad:push")
    assert system("rake -T vlad:push | grep push")
  end

  def test_checkout
    cmd = @source.checkout 'foo', 'bar'
    assert_equal "echo 'skipping checkout per vlad-push'", cmd
  end

  def test_export
    cmd = @source.export 'foo', '/tmp'
    assert_equal 'cp -r /tmp/repo /tmp', cmd
  end

  def test_revision
    out = @source.revision 'foo'
    assert_equal '/tmp/repo', out
  end

  def test_push
    cmd = @source.push 'example.com' 
    assert_equal 'scp -i ~/.ssh/id_rsa_example /tmp/testapp-12345678910.tgz example.com:/tmp/testapp-12345678910.tgz', cmd
  end

  def test_push_extract
    cmd = @source.push_extract
    assert_equal 'if [ -e /tmp/repo ]; then rm -rf /tmp/repo; fi && mkdir -p /tmp/repo && cd /tmp/repo && tar -xzf /tmp/testapp-12345678910.tgz', cmd
  end

  def test_push_cleanup
    cmd = @source.push_cleanup
    assert_equal 'rm -vrf /tmp/testapp-*.tgz && if [ -e /tmp/repo ]; then rm -rf /tmp/repo; fi', cmd 
  end

  def test_compress
    cmd = @source.compress
    assert_equal 'tar -czf /tmp/testapp-12345678910.tgz --exclude "\.git*" --exclude "\.svn*" .', cmd
  end

end
