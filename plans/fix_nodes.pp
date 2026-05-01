# @summary Plan to carry out automated fixes found by the health_check task
#
# @author Tony Green <tgreen@bandcamp.tv>
#
# @see https://github.com/voxpupuli/puppet_health_check
#
plan healthcheck::fix_nodes(
  TargetSpec $nodes,
  Boolean    $target_noop_state      = false,
  Integer    $target_runinterval     = 1800,
  Boolean    $target_service_enabled = true,
  Boolean    $target_service_running = true,
) {
  # Return codes
  # 0   : Clean
  # 1   : Health check couldn't run
  # 3   : Issue found but fixed
  # 4   : Issue found but automated fix failed
  # 100 : Issues remaining at the end of the check

  without_default_logging() || {
    $first_check = run_task('puppet_health_check::agent_health',
      $nodes,
      target_noop_state      => $target_noop_state,
      target_service_enabled => $target_service_enabled,
      target_service_running => $target_service_running,
      target_runinterval     => $target_runinterval,
      '_catch_errors'        => true
    )
    # Loop around the results from the fleet wide check to
    # see where we stand and what needs to be fixed.
    $first_check.each | $result | {
      $node = $result.target.name
      # Return error for those that couldn't run the health check
      unless $result.ok {
        notice "${node},1,health check failed"
        next()
      }

      # Return clean for those that don't have any issues
      if $result.value['state'] == 'clean' {
        notice "${node},0,heath check passed"
        next()
      }

      $response = $result.value

      # Fix the noop issues
      if $response['issues']['noop'] {
        $noop = run_task('puppet_health_check::fix_noop', $node, target_state => $target_noop_state, '_catch_errors' => true)
        if $noop.ok {
          notice "${node},3,noop fixed"
        } else {
          notice "${node},4,could not fix noop"
        }
      }

      # Fix the lockfile issues
      if $response['issues']['lock_file'] {
        $lockfile = run_task('puppet_health_check::fix_lockfile', $node, '_catch_errors' => true)
        if $lockfile.ok {
          notice "${node},3,lockfile fixed"
        } else {
          notice "${node},4,could not fix lockfile"
        }
      }

      # Fix the runinterval issues
      if $response['issues']['runinterval'] {
        $runinterval = run_task('puppet_health_check::fix_runinterval', $node, target_state => $target_runinterval, '_catch_errors' => true)
        if $runinterval.ok {
          notice "${node},3,runinterval fixed"
        } else {
          notice "${node},4,could not fix runinterval"
        }
      }

      # Fix last_run issue
      if $response['issues']['last_run'] {
        $last_run = run_command('puppet agent -t', $node, '_catch_errors' => true)
        if $last_run.ok {
          notice "${node},3,puppet agent run"
        } else {
          notice "${node},4,puppet agent failed"
        }
      }

      # Fix service enabled issue
      if $response['issues']['enabled'] {
        $enabled_action = $target_service_enabled ? {
          true  => 'enable',
          false => 'disable',
        }

        $enabled = run_task('service', $node, name => 'puppet', action => $enabled_action, '_catch_errors' => true)
        if $enabled.ok {
          notice "${node},3,puppet service enabled set to ${target_service_enabled}"
        } else {
          notice "${node},4,puppet service enabled not able to be set to ${target_service_enabled}"
        }
      }

      # Fix service running issue
      if $response['issues']['running'] {
        $service_action = $target_service_running ? {
          true  => 'start',
          false => 'stop',
        }

        $running = run_task('service', $node, name => 'puppet', action => $service_action, '_catch_errors' => true)
        if $running.ok {
          notice "${node},3,puppet service set to ${target_service_running}"
        } else {
          notice "${node},4,puppet service not able to be set to ${target_service_running}"
        }
      }

      # Do the second run to validate that things have been fixed
      $second_check = run_task('puppet_health_check::agent_health',
        $node,
        target_noop_state      => $target_noop_state,
        target_service_enabled => $target_service_enabled,
        target_service_running => $target_service_running,
        target_runinterval     => $target_runinterval,
        '_catch_errors' => true
      )
      $second_check.each | $result | {
        $result.value['issues'].each | $issue | {
          # Return any residual issues
          notice "${node},100,${issue[1]}"
        }
      }
    }
  }
}
