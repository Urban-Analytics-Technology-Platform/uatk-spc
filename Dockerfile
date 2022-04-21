FROM rust:1.60

WORKDIR /spc
COPY . .
RUN apt-get update
RUN apt-get install -y cmake sqlite3 libclang-dev
RUN cargo build --release

CMD ["./target/release/spc"]
