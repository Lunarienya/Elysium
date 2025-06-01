FROM golang:1.23-alpine AS builder

WORKDIR /app

ENV CGO_ENABLED=1

RUN apk add --no-cache nodejs npm make alpine-sdk

COPY go.mod go.sum .

RUN go mod download

COPY . .

ENV CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
RUN make install

FROM alpine:latest

RUN apk add --no-cache ca-certificates sqlite-libs

RUN mkdir -p /usr/bin
COPY --from=builder /usr/bin/drasl /usr/bin/drasl

RUN mkdir -p /usr/share/drasl
COPY --from=builder /usr/share/drasl /usr/share/drasl

CMD ["/usr/bin/drasl"
