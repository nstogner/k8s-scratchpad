# BUILD

FROM docker.io/library/golang:1.16 as build
WORKDIR /work
COPY . /work/
RUN CGO_ENABLED=0 go build -o /tmp/app .

# RUN

FROM gcr.io/distroless/static
WORKDIR /work

COPY --from=build --chown=nonroot:nonroot /tmp/app /work/app

USER nonroot:nonroot
ENTRYPOINT ["/work/app"]
