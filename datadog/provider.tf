provider "datadog" {
}

resource "datadog_monitor" "hostdown" {

  name    = "Host is Down"
  type    = "service check"
  message = "Host is down. Notify: @alessandro.vozza@microsoft.com"

  query = "\"datadog.agent.up\".over(\"*\").by(\"host\").last(2).count_by_status()"

  thresholds = {
    ok                = 1
    warning           = 1
    warning_recovery  = 1
    critical          = 1
    critical_recovery = 1
  }

  new_host_delay    = 300
  notify_no_data    = true
  renotify_interval = 60



  tags = ["uptime"]
}
