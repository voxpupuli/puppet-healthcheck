$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))
require 'puppet_x/puppet-community/tcp_validator'

# This file contains a provider for the resource type `tcp_conn_validator`,
# which validates the TCP connection.

Puppet::Type.type(:tcp_conn_validator).provide(:tcp_port) do
  desc "A provider for the resource type `tcp_conn_validator`,
        which validates the tcp connection."

  def exists?
    start_time = Time.now
    timeout = resource[:timeout]
    try_sleep = resource[:try_sleep]

    success = validator.attempt_connection

    while success == false && ((Time.now - start_time) < timeout)
      Puppet.debug("Failed to connect to the host; sleeping #{try_sleep} seconds before retry")
      sleep try_sleep
      success = validator.attempt_connection
    end

    if success
      Puppet.debug("Connected to the host in #{Time.now - start_time} seconds.")
    else
      Puppet.notice("Failed to connect to the host within timeout window of #{timeout} seconds; giving up.")
    end

    success
  end

  def create
    # If `#create` is called, that means that `#exists?` returned false, which
    # means that the connection could not be established... so we need to
    # cause a failure here.
    raise Puppet::Error, "Unable to connect to the  host. (#{@validator.tcp_server}:#{@validator.tcp_port})"
  end

  private

  # @api private
  def validator
    @validator ||= PuppetX::PuppetCommunity::TcpValidator.new(resource[:name], resource[:host], resource[:port])
  end

end
