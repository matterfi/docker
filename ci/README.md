# Open-Transactions Docker image for Continuous Integration

These images construct build environments for compiling and testing Open-Transactions

## Usage

### Building the image

```
docker image build -t opentransactions/ci:10 .
docker image build -t polishcode/matterfi-ci-fedora:32-1 .
docker image build -t polishcode/matterfi-ci-fedora:33-1      -f Dockerfile-fedora-33 .
docker image build -t polishcode/matterfi-ci-fedora:34-1      -f Dockerfile-fedora-34 .
docker image build -t polishcode/matterfi-ci-fedora:35-3      -f Dockerfile-fedora-35 .
docker image build -t polishcode/matterfi-ci-fedora:36-1      -f Dockerfile-fedora-36 .
docker image build -t polishcode/matterfi-ci-fedora:36-tidy-1 -f Dockerfile-fedora-36-tidy .
```

### Base Fedora version

Initially - 32
As part of OT-376 - updated successfuly to Fedora 35
Problems with Fedora 36:
- test-linux-gcc-nopch: failing tests:
  ```
  The following tests FAILED:
	  1 - ottest-blind (Subprocess aborted)
	  3 - ottest-blockchain-api (Subprocess aborted)
	  4 - ottest-blockchain-bip44 (Subprocess aborted)
	 14 - ottest-blockchain-activity-labels (Subprocess aborted)
	 47 - ottest-blockchain-regtest-rename (SEGFAULT)
	 81 - ottest-crypto-asymmetric (Failed)
	 82 - ottest-crypto-bip32 (Failed)
	 84 - ottest-crypto-bitcoin (Failed)
	126 - ottest-paymentcode-v1 (Failed)
	131 - ottest-rpc-list-accounts (Subprocess aborted)
	134 - ottest-rpc-send-payment-blockchain (SEGFAULT)
	136 - ottest-ui-amountvalidator (Subprocess aborted)
  ```
  some of them with a following problem:
  ```
    (7f21551bd440) opentxs::crypto::key::HD::CalculateFingerprint: Failed to calculate public key hash
    (7f21551bd440) opentxs::crypto::implementation::OpenSSL::Digest: Failed to initialize digest operation
  ```
- test-linux-gcc-full - same as test-linux-gcc-nopch
- build-linux-clang-nopch - change in OpenSSL API (1.* vs 3.*):
  ```
  FAILED: deps/packetcrypt/CMakeFiles/packetcrypt.dir/DifficultyTest.c.o 
/usr/bin/clang -DOPENTXS_EXPORT="__attribute__((visibility(\"default\")))" -DOT_VALGRIND=1 -I/home/output/include -I/home/output/src -I/home/src/include -I/home/src/src -isystem /home/src/deps/packetcrypt/packetcrypt_rs/packetcrypt-sys/packetcrypt/include -isystem /home/src/deps/packetcrypt/packetcrypt_rs/packetcrypt-sys/packetcrypt/src -g -fPIC -fwrapv -std=gnu11 -MD -MT deps/packetcrypt/CMakeFiles/packetcrypt.dir/DifficultyTest.c.o -MF deps/packetcrypt/CMakeFiles/packetcrypt.dir/DifficultyTest.c.o.d -o deps/packetcrypt/CMakeFiles/packetcrypt.dir/DifficultyTest.c.o -c /home/output/deps/packetcrypt/DifficultyTest.c
/home/output/deps/packetcrypt/DifficultyTest.c:164:5: error: used type 'void' where arithmetic or pointer type is required
    assert(BN_zero(out));
    ^~~~~~~~~~~~~~~~~~~~
/usr/include/assert.h:105:26: note: expanded from macro 'assert'
  ((void) sizeof ((expr) ? 1 : 0), __extension__ ({                     \
                  ~~~~~~ ^
/home/output/deps/packetcrypt/DifficultyTest.c:164:5: error: statement requires expression of scalar type ('void' invalid)
    assert(BN_zero(out));
    ^~~~~~~~~~~~~~~~~~~~
/usr/include/assert.h:106:7: note: expanded from macro 'assert'
      if (expr)                                                         \
      ^   ~~~~
  ```
- build-linux-clang-full - same as build-linux-clang-nopch


### Compiling opentxs

Compile scripts are located in the image /usr/bin/build-opentxs-clang.sh and /usr/bin/build-opentxs-gcc.sh and should be used as the image entrypoint

The entrypoint scripts one parameter for the named opentxs configuration from /var/lib/opentxs-config.sh.

Valid values are: test01 test02 test03 test04 test05 test06 test07 test08 prod nopch full

#### Example

```
docker run \
    --read-only \
    --tmpfs /tmp/build:rw,nosuid,size=2g \
    --mount type=bind,src=/path/to/opentxs,dst=/home/src \
    --mount type=bind,src=/path/to/build/directory,dst=/home/output \
    --entrypoint /usr/bin/build-opentxs-gcc.sh \
    -it opentransactions/ci:latest \
    full
```

```
docker run \
    --read-only \
    --tmpfs /tmp/build:rw,nosuid,size=2g \
    --mount type=bind,src=/path/to/opentxs,dst=/home/src \
    --mount type=bind,src=/path/to/build/directory,dst=/home/output \
    --entrypoint /usr/bin/build-opentxs-clang.sh \
    -it opentransactions/ci:latest \
    full
```

### Executing unit tests

Unit test scripts is located in the image at /usr/bin/test-opentxs.sh

Pass a numeric jobs argument to these scripts that matches the number of available cores.

#### Example

```
docker run \
    --tmpfs /tmp/build:rw,nosuid,size=2g \
    --mount type=bind,src=/path/to/opentxs,dst=/home/src \
    --mount type=bind,src=/path/to/build/directory,dst=/home/output \
    --entrypoint /usr/bin/test-opentxs.sh \
    -it opentransactions/ci:latest \
    2
```
