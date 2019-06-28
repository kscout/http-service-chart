{{/*
Specialized .Values.host default value logic
*/}}
{{- define "http-service.host" -}}
{{- if .Values.host -}}
{{ .Values.host }}
{{- else if eq .Values.global.env "prod" -}}
{{ .Values.defaultHost }}
{{- else -}}
{{ .Values.global.env }}-{{ .Values.defaultHost }}
{{- end -}}
{{- end -}}
