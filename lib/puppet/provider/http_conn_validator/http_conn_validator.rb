$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))
require 'puppet_x/puppet-community/http_validator'

# This file contains a provider for the resource type `http_conn_validator`,
# which validates an HTTP connection by attempting an http(s) connection.

Puppet::Type.type(:http_conn_validator).provide(:http_conn_validator) do
  desc "A provider for the resource type `http_conn_validator`,
        which validates an HTTP connection by attempting an http(s)
        connection to the server."

  # Test to see if the resource exists, returns true if it does, false if it
  # does not.
  #
  # Here we simply monopolize the resource API, to execute a test to see if the
  # database is connectable. When we return a state of `false` it triggers the
  # create method where we can return an error message.
  #
  # @return [bool] did the test succeed?
  def exists?
    start_time = Time.now
    timeout = resource[:timeout]
    try_sleep = resource[:try_sleep]

    success = validator.attempt_connection

    while success == false && ((Time.now - start_time) < timeout)
      # It can take several seconds for an HTTP  service to start up;
      # especially on the first install.  Therefore, our first connection attempt
      # may fail.  Here we have somewhat arbitrarily chosen to retry every 2
      # seconds until the configurable timeout has expired.
      Puppet.notice("Failed to make an HTTP connection; sleeping #{try_sleep} seconds before retry")
      sleep try_sleep
      success = validator.attempt_connection
    end

    if success
      Puppet.debug("Connected to the host in #{Time.now - start_time} seconds.")
    else
      Puppet.notice("Failed to make an HTTP connection within timeout window of #{timeout} seconds; giving up.")
    end

    success
  end

  # This method is called when the exists? method returns false.
  #
  # @return [void]
  def create
    # If `#create` is called, that means that `#exists?` returned false, which
    # means that the connection could not be established... so we need to
    # cause a failure here.
    raise Puppet::Error, "Unable to connect to the HTTP server! (#{@validator.test_uri.host}:#{@validator.test_uri.port} with HTTP code #{@validator.expected_code})"
  end

  # Returns the existing validator, if one exists otherwise creates a new object
  # from the class.
  #
  # @api private
  def validator
    @validator ||= PuppetX::PuppetCommunity::HttpValidator.new(
      resource[:name],
      resource[:host],
      resource[:port],
      resource[:use_ssl],
      resource[:test_url],
      resource[:expected_code],
      resource[:verify_peer]
    )
  end
end
