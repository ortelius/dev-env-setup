{{/*
Fullname
*/}}
{{- define "backstage.appFullname" -}}
{{ include "backstage.fullname" . }}-app
{{- end }}

{{/*
Common labels
*/}}
{{- define "backstage.appLabels" -}}
{{ include "backstage.labels" . }}
app.kubernetes.io/component: app
backstage.io/kubernetes-id: backstage-frontend
{{- end }}

{{/*
Selector labels
*/}}
{{- define "backstage.appSelectorLabels" -}}
{{ include "backstage.selectorLabels" . }}
app.kubernetes.io/component: app
backstage.io/kubernetes-id: backstage-frontend
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "backstage.appServiceAccountName" -}}
{{- if .Values.app.serviceAccount.create }}
{{- default (printf "%s-app" (include "backstage.fullname" .)) .Values.app.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.app.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
The image to use
*/}}
{{- define "backstage.appImage" -}}
{{- printf "%s:%s" .Values.app.image.repository (default .Chart.AppVersion .Values.app.image.tag) }}
{{- end }}

{{/*
Create config name.
*/}}
{{- define "backstage.appConfigName" -}}
{{- template "backstage.appFullname" . -}}-app-config
{{- end -}}
