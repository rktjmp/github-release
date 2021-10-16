FROM alpine:3.14

RUN apk add --no-cache file curl jq ca-certificates

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
