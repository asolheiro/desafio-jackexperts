{{/* Função para ler o conteúdo de um arquivo */}}
{{- define "readFile" -}}
{{ printf "%s" (readFile . ) }}
{{- end -}}
