# HTTP Service Chart
Helm chart which exposes an HTTP service and publishes Prometheus metrics.

# Table Of Contents
- [Overview](#overview)
- [Use](#use)
- [Values](#values)
- [App Container Image](#app-container-image)

# Overview
Caddy reverse proxy to arbitrary HTTP service container.  

Exposes the HTTP service via a Route resource.  
Exposes Caddy's Prometheus metrics via a Service.

Meant to be used as a sub-chart. See [use section](#use)

# Use
This repository does not deploy a resource on its own.  
Meant to be used as a sub-chart.  
Create a chart which deploys a specific application located in 
`<Chart directory>`, then:

1. Add this repository as a Git submodule to your repository:
   ```
   git submodule add git@github.com:kscout/http-service-chart.git <Chart directory>/charts/http
   ```
2. Set [global values](#global-values) in `<Chart directory>/values.yaml`
3. Set [chart values](#chart-values) in `<Chart directory>/values.yaml`, make 
   sure to prefix them with `http.`

# Values
Helm values dictate how this chart will deploy resources.

## Global Values
These values are shared between all charts, sub-charts and all:

- `global.env` (String): Deployment environment
- `global.app` (String): Name of application

## Chart Values
These values are specific to this HTTP service chart.  
If this chart is being used as a sub-chart prefix these keys with `http`.  

These keys are required:

- `defaultHost` (String): Full host to expose HTTP service through, prefixed
  with `global.env` if `global.env != "prod"`
- `port` (String): Port [app container image](#app-container-image) listens for
  HTTP on
  
See the [`values.yaml` file](values.yaml) for documentation on the many other 
optional keys.

# App Container Image
This chart serves HTTP traffic to containers which meet the 
following pre-conditions:

- Container image in the repository:
  `docker.io/kscout/{{ .Values.global.app }}`. Where `{{ .Values.global.app }}`
  is the [`global.app` global value](#global-values).
- Image tags in format: `{{ .Values.global.env }}-latest`. Where 
  `{{ .Values.global.env }}` is the [`global.env` global value](#global-values).
- Serves HTTP traffic on the port specified by the
  [`port` chart value](#chart-values)
- Responds to an HTTP GET request at the `/health` path with status `200 OK`


