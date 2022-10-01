# MatterFi casper-cpp-sdk Docker image for Continuous Integration

These images construct build environments for compiling and testing casper-cpp-sdk under Linux

## Usage

### Building the image

Alpine image is for dev purposes only, for CI we are using ubuntu-based image.
Sizes:
- alpine-based: 464 MB
- debian-based: 631 MB
- ubuntu-based: 691 MB
However, alpine is a rolling distro. We are going with debian then.

```
docker image build -t polishcode/matterfi-casper-cpp-sdk-alpine:1      -f Dockerfile-alpine .
docker image build -t polishcode/matterfi-casper-cpp-sdk-debian:1      -f Dockerfile-debian .
docker image build -t polishcode/matterfi-casper-cpp-sdk-ubuntu:1      -f Dockerfile-ubuntu .
```
