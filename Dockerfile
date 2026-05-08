# syntax=docker/dockerfile:1

# Build the C++ application with Chainguard's GCC image.
FROM cgr.dev/trineta.net/gcc-glibc:latest@sha256:c0e5f618913e00dcc58605fd914c3f9acc579ddddb0e5f7a4bde1621b5d33962 AS build

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
FROM cgr.dev/trineta.net/glibc-dynamic:latest@sha256:1dab7ab70258fd07576ec1100a4bec57e8c729d2c4229a77ac9cf49b74ccae08

WORKDIR /app

COPY --from=build /out/ /app/

# Start the compiled banking application.
ENTRYPOINT ["/app/main"]