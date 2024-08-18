FROM ubuntu:24.04 AS downloader

RUN apt-get update && \
    apt-get install -y \
    wget \
    ca-certificates

ENV BITCOIN_VERSION=26.2
ENV BITCOIN_SHA256=77c63bec845b318c07f3a7660c579f63da18b58d25699ab8b8df6034e8ed55c0
ENV ARCH=x86_64-linux-gnu

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-${ARCH}.tar.gz && \
    echo "$BITCOIN_SHA256  bitcoin-${BITCOIN_VERSION}-${ARCH}.tar.gz" | sha256sum -c - && \
    tar -xzf bitcoin-${BITCOIN_VERSION}-${ARCH}.tar.gz

RUN mkdir -p /.bitcoin/wallets

# Stage 2: Create the scratch-based image
FROM scratch

ENV BITCOIN_VERSION=26.2

USER 1001:1001

COPY --from=downloader /bitcoin-${BITCOIN_VERSION}/bin/bitcoind /usr/local/bin/bitcoind
COPY --from=downloader /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=downloader /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=downloader /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=downloader /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6
COPY --from=downloader /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1
COPY --from=downloader /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

WORKDIR /.bitcoin
COPY --from=downloader /.bitcoin/wallets /.bitcoin/wallets

EXPOSE 8332 8333

CMD ["bitcoind"]