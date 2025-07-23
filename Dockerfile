# base image golang --v 1.22.5
FROM golang:1.22.5 as base

# setting a work directory
# all commands after this will be executed in this work directory
WORKDIR /app

# copying the go.mod file
# required because dependencies are stored in this go.mod file
COPY go.mod ./

# all dependencies will be downloaded if exist or if added in future (if go.mod is updated)
RUN go mod download

# copy the source code to the docker image
COPY . .

# build the application and a binary (main) will be created in the image
RUN go build -o main .

# final stage using distroless image
# for image size reduction
FROM gcr.io/distroless/base

# copy the main binary from base to the distroless image
COPY --from=base /app/main .

# Copy the static files from the previous stage or base stage to a folder(static)
COPY --from=base /app/static ./static

# expose the port used for application running
EXPOSE 8080

# run application
CMD ["./main"]