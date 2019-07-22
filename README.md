# HTTP Service Chart
Helm chart which exposes an HTTP service and publishes Prometheus metrics.

# Table Of Contents
- [Overview](#overview)
- [Use](#use)
- [Values](#values)
- [App Container Image](#app-container-image)
- [Release Checklist](#release-checklist)

# Overview
Runs any HTTP service container which 
meets [app container image guidelines](#app-container-image) 
on OpenShift 3+

Exposes the HTTP service via a Route resource.  
Exposes Prometheus metrics via a Service.

Meant to be used as a sub-chart. See [use section](#use)

# Use
This repository provides a [Helm chart](https://helm.sh) which is meant to be
used as a sub-chart. All you have to do to use it is add it to your own Helm 
chart's `charts/` directory:

1. Create a chart which deploys a specific application located in 
   `<Chart directory>`
2. Add this repository as a Git submodule to your repository:
   ```
   git submodule add git@github.com:kscout/http-service-chart.git <Chart directory>/charts/http
   ```
3. Checkout the latest release of this repository:
   ```
   cd <Chart directory>/charts/http
   git checkout v0.2.1
   ```
4. Set [global values](#global-values) in `<Chart directory>/values.yaml`
5. Set [chart values](#chart-values) in `<Chart directory>/values.yaml`, make 
   sure to prefix them with `http.`
6. Ensure app container 
   meets [app container image guidelines](#app-container-image)

# Values
Helm values dictate how this chart will deploy resources.

## Global Values
These values are shared between all charts and sub-charts:

- `global.env` (String): Deployment environment
- `global.app` (String): Name of application

## Chart Values
These values are specific to this HTTP service chart.  
If this chart is being used as a sub-chart prefix these keys with `http`.  

These keys are required:

- `defaultHost` (String): Full host to expose HTTP service through, prefixed
  with `global.env` if `global.env != "prod"`
  - Note: This key is only required if you wish to expose the service to 
	external network traffic. If you wish to keep the service private do not set
	this key. Additionally set the `routeEnabled` key to `false`.
- `port` (String): Port [app container image](#app-container-image) listens for
  HTTP on
  
These keys are optional but useful:

- `metricsEnabled` (Boolean): If true: An internal Service resource will be 
  created which publishes a Prometheus metrics scrape target.
- `metricsPort` (String): If `metricsEnabled == true`: The container port from 
  which the metrics service will collect metrics.
- `configMap` ([]Object): If present: A ConfigMap resource will be created who's
  contents are items which follow the [Config Item Schema](#config-item-schema)
- `configMapMount` (String): If present: ConfigMap resource created by the above
  `configMap` key will be mounted in the app container as a volume under the 
  specified path
- `secret` ([]Object): If present: A Secret resource will be created, who's
  contents are items which follow the [Config Item Schema](#config-item-schema)
- `secretMount` (String): If present: Secret resource created by the above
  `secret` key will be mounted in the app container as a volume under the
  specified path
  
See the [`values.yaml` file](values.yaml) for complete documentation of 
all keys.

## Config Item Schema
The `configMap` and `secret` value file keys both follow the same schema.

Array items should have the keys:

- `key` (String): Key in the ConfigMap or Secret to create
- `envKey` (String): If present: The key created in the ConfigMap of Secret will
  be passed to the app container via an environment variable with `envKey` as
  its name.
- `value` (String): Value to put in ConfigMap or Secret under `key`

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

# Release Checklist
When a new release occurs:

1. Bump `version` in [`Chart.yaml`](Chart.yaml)
2. Update instruction step #3 in the [use section](#use) to checkout latest tag
3. [Create release](https://github.com/kscout/http-service-chart/releases/new) 
   tagged `v<chart version>`
4. Follow additional release instructions in [common Helm chart releases playbook](https://github.com/kscout/site-reliability/tree/master/playbooks/releases/common-helm-charts)
