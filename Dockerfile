FROM alpine
WORKDIR /app
COPY server-monitor.sh .
RUN apk add --no-cache bash coreutils procps iputils && touch /app/monitor.log
