{{- define "vault.annotations"}}
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/agent-pre-populate-only: "true"
vault.hashicorp.com/role: '{{ .Release.Namespace }}-{{ .Values.service_name }}'
{{ range .Values.vault.secrets }}
  {{ if eq .type "env"}}
vault.hashicorp.com/agent-inject-secret-env-{{ .name }}: 'secret/{{ $.Release.Namespace }}/{{ $.Values.service_name }}/data/{{ .name }}'
vault.hashicorp.com/agent-inject-template-env-{{ .name }}: |-
  {{`{{ with secret "`}}secret/{{ $.Release.Namespace }}/{{ $.Values.service_name }}/data/{{ .name }}{{`" }}
    {{ range $k, $v := .Data.data }}
      {{ $k }}={{ $v }}
    {{ end }}{{ end }}`}}
  {{ else if eq .type "file" }}
vault.hashicorp.com/agent-inject-secret-{{ .name }}: 'secret/{{ $.Release.Namespace }}/{{ $.Values.service_name }}/data/{{ .name }}'
vault.hashicorp.com/agent-inject-template-{{ .name }}: |-
  {{`{{ with secret "`}}secret/{{ $.Release.Namespace }}/{{ $.Values.service_name }}/data/{{ .name }}{{`" }}{{ base64Decode .Data.data.data }}{{ end }}`}}
  {{ end }}
{{ end }}
{{ range $mount, $secrets := .Values.vault.shared_secrets }}
  {{ range $secret := $secrets }}
    {{ if eq .type "env" }}
vault.hashicorp.com/agent-inject-secret-env-{{ $mount }}-{{ $secret.name }}: 'secret/{{ $.Release.Namespace }}/shared/{{ $mount }}/data/{{ $secret.name }}'
vault.hashicorp.com/agent-inject-template-env-{{ $mount }}-{{ .name }}: |-
  {{`{{ with secret "`}}secret/{{ $.Release.Namespace }}/shared/{{ $mount }}/data/{{ $secret.name }}{{`" }}
    {{ range $k, $v := .Data.data }}
      {{ $k }}={{ $v }}
    {{ end }}{{ end }}`}}
    {{ else if eq .type "file" }}
vault.hashicorp.com/agent-inject-secret-{{ $secret.name }}: 'secret/{{ $.Release.Namespace }}/shared/{{ $mount }}/data/{{ $secret.name }}'
vault.hashicorp.com/agent-inject-template-{{ .name }}: |-
  {{`{{ with secret "`}}secret/{{ $.Release.Namespace }}/shared/{{ $mount }}/data/{{ $secret.name }}{{`" }}{{ base64Decode .Data.data.data }}{{ end }}`}}
    {{ end }}
  {{ end }}
{{ end }}
vault.hashicorp.com/service: '{{ .Values.vault.address }}'
{{- end}}


{{- define "default.annotations"}}
stockx.io/helm-chart-name: '{{ .Chart.Name }}'
stockx.io/helm-release: '{{ .Release.Name }}'
stockx.io/helm-revision: '{{ .Release.Revision }}'
stockx.io/team: '{{ .Values.stockx.team }}'
{{- end}}

{{- define "default.labels"}}
app: '{{ .Chart.Name }}'
release: '{{ .Release.Name }}'
type: '{{ .Values.labels.type }}'
{{- end}}
