# syntax=docker/dockerfile:1

# Build the C++ application with Chainguard's GCC image.
FROM cgr.dev/trineta.net/gcc-glibc:latest@sha256:3f42087687b2ce4743bb6a47bf179632c77a1339dc34caa87d5d72c87597d711 AS build

WORKDIR /src

COPY Makefile ./
COPY src ./src

RUN make

# Include runtime data when it exists. The app expects users.dat in its
# working directory.
RUN mkdir -p /out \
    && cp bin/main /out/main \
    && if [ -f users.dat ]; then cp users.dat /out/users.dat; fi

# Run with Chainguard's minimal glibc runtime image.
FROM cgr.dev/trineta.net/glibc-dynamic:latest@sha256:f73a298435766b065e3d5105397d1eb24f74ed1f44937767ed5d8677765a460e

WORKDIR /app

COPY --from=build /out/ /app/

# Start the compiled banking application.
ENTRYPOINT ["/app/main"]