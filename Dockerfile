# syntax=docker/dockerfile:1

# Build the C++ application with Chainguard's GCC image.
FROM cgr.dev/trineta.net/gcc-glibc:latest@sha256:5f43ca55baee75902356c658ed6eaeadbd8f40dbafd890232a1ecf1a3b7a7205 AS build

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
FROM cgr.dev/trineta.net/glibc-dynamic:latest@sha256:036906f7c14ac019a1d7d5ae608dcb39ee44df1ee5c4162c815b3f0d3f1a2230

WORKDIR /app

COPY --from=build /out/ /app/

# Start the compiled banking application.
ENTRYPOINT ["/app/main"]