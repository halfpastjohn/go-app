FROM golang:1.14.6-alpine3.12 as builder
COPY go.mod go.sum /go/src/gitlab.com/halfpastjohn/go-app/
WORKDIR /go/src/gitlab.com/halfpastjohn/go-app
RUN go mod download
COPY . /go/src/gitlab.com/halfpastjohn/go-app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/go-app gitlab.com/halfpastjohn/go-app

FROM alpine
RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY --from=builder /go/src/gitlab.com/halfpastjohn/go-app/build/go-app /usr/bin/go-app
EXPOSE 8010 8010
ENTRYPOINT ["/usr/bin/go-app"]
