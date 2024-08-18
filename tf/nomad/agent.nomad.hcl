client {
  options = {
    "driver.allowlist"      = "docker"
    "fingerprint.allowlist" = "network"
    "user.denylist"         = "root,ubuntu,Administrator"
    "user.checked_drivers"  = "docker"
  }
}

// to be used to set acls and not give free access to cluster for everyone
acl {
  enabled = true
}