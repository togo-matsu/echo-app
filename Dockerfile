# 変更前 (例: FROM golang:1.24-alpine など)
# 変更後: 1.26 系の最新イメージを指定
FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o echo-app main.go

# 実行環境ステージ（マルチステージビルドの場合）
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/echo-app .
EXPOSE 8080
CMD ["./echo-app"]