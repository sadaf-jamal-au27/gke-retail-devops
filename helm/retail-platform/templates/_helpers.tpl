{{- define "retail.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "retail.labels" -}}
app.kubernetes.io/name: {{ include "retail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: retail-platform
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
retail.platform/env: {{ .Values.global.env | quote }}
{{- end -}}

{{- define "retail.image" -}}
{{- printf "%s/%s:%s" .Values.global.imageRegistry .name .Values.global.imageTag -}}
{{- end -}}
