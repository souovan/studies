FROM golang AS buildando

ENV GO111MODULE="auto"
WORKDIR /app
ADD . /app
RUN go build -o meugo


FROM alpine
WORKDIR /giropops
COPY --from=buildando /app/meugo /giropops/ 
ENTRYPOINT ./meugo
