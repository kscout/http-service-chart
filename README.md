# HTTP Service Chart
Helm chart which exposes an HTTP service and publishes Prometheus metrics.

# Table Of Contents
- [Overview](#overview)
- [Values](#values)
- [Container Image](#container-image)

# Overview
Caddy reverse proxy to arbitrary HTTP service container.  

Exposes the HTTP service via a Route resource.  
Exposes Caddy's Prometheus metrics via a Service.

# Values
Chart values:

- `global.env` (String): Deployment environment
- `global.app` (String): Name of application
- `defaultHost` (String): Full host to expose HTTP service through, prefixed
  with `global.env` if `global.env != "prod"`

# Container Image
The container image for the HTTP service container must be in the repository:

```
docker.io/kscout/<global.app>
```

Tags must be in the format:

```
<global.env>-latest
```
