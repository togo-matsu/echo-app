FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o echo-app main.go

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /app/echo-app .
USER 65532:65532
EXPOSE 8080
ENTRYPOINT ["/echo-app"]
