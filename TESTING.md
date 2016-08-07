### Test locally

An acceptance test harness runs on
[circleci.com](https://circleci.com/gh/jumanjihouse/docker-duoauthproxy)
for each pull request.
The easiest way to test is to open a PR, which tests changes on CircleCI.

As an alternative, you can run the acceptance test harness locally to verify operation.
First, create a free personal account at https://signup.duosecurity.com/
and create two integrations.

First integration:

* Integration type: RADIUS
* Integration name: test-radius-allow
* Policy: Allow access (Unenrolled users will pass through without two-factor authentication)
* Username normalization: None

Second integration:

* Integration type: RADIUS
* Integration name: test-radius-deny
* Policy: Deny access (Unenrolled users will be denied access)
* Username normalization: None

:warning: This test harness assumes your Duo account does *not*
have a user named "test".

Create a local file at the root of the repo named `environment`.
The file holds keys for the integrations you created above.

    # environment
    export API_HOST=api-xxxxxxxx.duosecurity.com

    # This integration allows users without 2fa.
    export IKEY_ALLOW=DIxxxxxxxxxxxxxxxxxx
    export SKEY_ALLOW=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    # This integration denies users without 2fa.
    export IKEY_DENY=DIxxxxxxxxxxxxxxxxxx
    export SKEY_DENY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    # Test harness uses a real radius server and client.
    # See https://github.com/jumanjihouse/docker-radius
    # Specify an optimistic or pessimistic tag here.
    export RADIUS_TAG="latest"

Run the test harness on a single image:

    script/test.sh

The test harness uses [BATS](https://github.com/sstephenson/bats).
Output resembles:

    ✓ radius auth via duo authproxy is allowed when 2fa succeeds
    ✓ radius auth via duo authproxy is rejected when 2fa fails
    ✓ There are no suid files
    ✓ duo user exists
    ✓ duo user is denied interactive login
    ✓ duo is the only user account
    ✓ duo is the only user account
    ✓ duo group exists
    ✓ duo is the only group account
    ✓ duo is the only group account
    ✓ bash is not installed
    ✓ chown is available
    ✓ chgrp is available
    ✓ ln is available
    ✓ chmod is available

    15 tests, 0 failures
