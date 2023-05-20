FROM rust:1.68.2-alpine
ARG DATABASE_URL

# WORKDIR /usr/src/myapp
# COPY . .

RUN apk add libc-dev pkgconfig libressl-dev

ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse
RUN cargo install sqlx-cli

ENV DATABASE_URL=$DATABASE_URL
CMD ["sqlx", "migrate", "run", "--source", "/sqlx-initdb.d" ]


