# syntax=docker/dockerfile:1

# Build the C++ application with Chainguard's GCC image.
FROM cgr.dev/trineta.net/gcc-glibc:latest@sha256:8be7e7f2196b7d7bc31fdc02fdf18ad9c304194ebd67bcbe103140e9fa485c85 AS build

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
FROM cgr.dev/trineta.net/glibc-dynamic:latest@sha256:98b03533c9e7a473391550a3e66ae84cf8820edf145dbff695740cccdc3fa73c

WORKDIR /app

COPY --from=build /out/ /app/

# Start the compiled banking application.
ENTRYPOINT ["/app/main"]