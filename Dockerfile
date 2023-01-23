FROM golang:1.19-alpine as build

RUN apk add --no-cache git
WORKDIR /editorconfig-checker
COPY . /editorconfig-checker
RUN GO111MODULE=on CGO_ENABLED=0 go build -ldflags "-X main.version=$(cat VERSION | tr -d '\n')" -o bin/editorconfig-checker ./cmd/editorconfig-checker/main.go

#

FROM alpine:latest

RUN apk add --no-cache git
WORKDIR /check/
COPY --from=build /editorconfig-checker/bin/editorconfig-checker /usr/bin

CMD ["editorconfig-checker"]
