resource "datadog_synthetics_test" "app_http_check" {
  name      = "Application HTTP Health Check"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = ["aws:eu-central-1"]
  tags      = ["env:production", "app:redmine"]

  request_definition {
    method = "GET"
    url    = "https://${var.domain_name}"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "5000"
  }

  options_list {
    tick_every = 300
    min_location_failed = 1

    retry {
      count    = 2
      interval = 500
    }

    monitor_options {
      renotify_interval = 120
    }
  }

  message = <<-EOT
    Application is not responding at https://${var.domain_name}

    HTTP health check failed. The application may be down or unreachable.

    @all
  EOT
}

resource "datadog_monitor" "app_uptime" {
  name    = "Application Uptime Monitor"
  type    = "service check"
  message = <<-EOT
    Application health check failed on {{host.name}}.

    The Datadog agent cannot reach the application on port ${var.app_port}.
    Check if the Docker container is running.

    @all
  EOT

  query = "\"http.can_connect\".over(\"instance:app_health_check\").by(\"host\").last(3).count_by_status()"

  monitor_thresholds {
    critical = 3
    warning  = 1
    ok       = 1
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60
  tags              = ["env:production", "app:redmine"]
}
