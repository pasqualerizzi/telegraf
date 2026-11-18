FROM golang:1.27-alpine AS build
RUN apk add --no-cache git
WORKDIR /src
RUN git clone --depth 1 --branch opcua-listener-event-fixes https://github.com/pasqualerizzi/telegraf.git .
RUN go test -short ./plugins/common/opcua/... ./plugins/inputs/opcua_listener/...
RUN CGO_ENABLED=0 go build -tags "custom,inputs.opcua_listener,inputs.cpu,inputs.disk,inputs.diskio,inputs.mem,inputs.net,inputs.processes,inputs.swap,inputs.system,outputs.file,outputs.influxdb_v2,outputs.mqtt,serializers.json,serializers.influx" -o /telegraf ./cmd/telegraf
FROM telegraf:1.40-alpine
COPY --from=build /telegraf /usr/bin/telegraf