Puppet::Type.newtype(:tcp_conn_validator) do

  @doc = "Verify that a TCP connection can be successfully established between a node
          and the expected host.  Its primary use is as a precondition to
          prevent configuration changes from being applied if the host cannot be
          reached, but it could potentially be used for other purposes such as monitoring."

  ensurable

  newparam(:name, :namevar => true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:host) do
    desc 'An array containing DNS names or IP addresses of the host where the expected service should be running.'
    munge do |value|
      Array(value).first
    end
  end

  newparam(:reachable) do
    desc 'Should the server be responding or not'
    defaultto true
  end

  newparam(:port) do
    desc 'The port that the server should be listening on.'
  end

  newparam(:try_sleep) do
    desc 'The time to sleep in seconds between ‘tries’.'
    defaultto 1

    validate do |value|
      # This will raise an error if the string is not convertible to an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end

  newparam(:timeout) do
    desc 'The max number of seconds that the validator should wait before giving up and deciding that the service is not running; defaults to 60 seconds.'
    defaultto 60

    validate do |value|
      # This will raise an error if the string is not convertible to an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end

end
