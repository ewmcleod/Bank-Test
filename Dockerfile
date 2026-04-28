# syntax=docker/dockerfile:1

# Build the C++ application with Chainguard's GCC image.
FROM cgr.dev/trineta.net/gcc-glibc:latest AS build

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
FROM cgr.dev/trineta.net/glibc-dynamic:latest

WORKDIR /app

COPY --from=build /out/ /app/

# Start the compiled banking application.
ENTRYPOINT ["/app/main"]