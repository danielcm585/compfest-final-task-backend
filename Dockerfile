FROM golang:1.14.6-alpine3.12 as builder

COPY go.mod go.sum /go/src/cfbackendapp/

WORKDIR /go/src/cfbackendapp

RUN go mod download

COPY . /go/src/cfbackendapp

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/app

FROM alpine

RUN apk add --no-cache ca-certificates && update-ca-certificates

COPY --from=builder /go/src/cfbackendapp/build/app /usr/bin/cfbackendapp

EXPOSE 8080 8080
ENTRYPOINT ["/usr/bin/cfbackendapp"]