
FROM golang:1.12.6-alpine as builder

RUN apk add --no-cache git curl make gcc libc-dev
RUN mkdir -p /src/build && chmod go-w /go/bin

ADD . /src/build/
WORKDIR /src/build/
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

FROM scratch
COPY --from=builder /src/build/main /app/
WORKDIR /app/
