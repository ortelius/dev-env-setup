{{/*
Fullname
*/}}
{{- define "backstage.backendFullname" -}}
{{ include "backstage.fullname" . }}-backend
{{- end }}

{{/*
Common labels
*/}}
{{- define "backstage.backendLabels" -}}
{{ include "backstage.labels" . }}
app.kubernetes.io/component: backend
backstage.io/kubernetes-id: backstage-backend
{{- end }}

{{/*
Selector labels
*/}}
{{- define "backstage.backendSelectorLabels" -}}
{{ include "backstage.selectorLabels" . }}
app.kubernetes.io/component: backend
backstage.io/kubernetes-id: backstage-backend
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "backstage.backendServiceAccountName" -}}
{{- if .Values.backend.serviceAccount.create }}
{{- default (printf "%s-backend" (include "backstage.fullname" .)) .Values.backend.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.backend.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
The image to use
*/}}
{{- define "backstage.backendImage" -}}
{{- printf "%s:%s" .Values.backend.image.repository (default .Chart.AppVersion .Values.backend.image.tag) }}
{{- end }}

{{/*
Create config name.
*/}}
{{- define "backstage.backendConfigName" -}}
{{- template "backstage.backendFullname" . -}}-app-config
{{- end -}}
