FROM golang

ENV GO111MODULE="auto"
WORKDIR /app
ADD . /app
RUN go build -o meugo
ENTRYPOINT ./meugo
