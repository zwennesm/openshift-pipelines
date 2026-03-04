FROM rust:1.93.1-slim-bullseye AS build
WORKDIR /build

RUN rustup target add x86_64-unknown-linux-musl

RUN --mount=type=bind,source=src,target=/build/src \
    --mount=type=bind,source=Cargo.toml,target=/build/Cargo.toml \
    --mount=type=bind,source=Cargo.lock,target=/build/Cargo.lock \
    --mount=type=cache,target=/build/target/ \
    --mount=type=cache,target=/usr/local/cargo/git/db \
    --mount=type=cache,target=/usr/local/cargo/registry/ \
    cargo build --release --locked --target x86_64-unknown-linux-musl && \
    cp /build/target/x86_64-unknown-linux-musl/release/rust-http /build/server

FROM scratch

COPY --from=build /build/server ./server

EXPOSE 8000

CMD ["./server"]