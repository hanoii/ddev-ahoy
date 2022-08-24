setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-ahoy
  mkdir -p $TESTDIR
  export PROJNAME=test-ahoy
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  cp $DIR/tests/testdata/.ddev/* "${TESTDIR}"/.ddev
  cp $DIR/tests/testdata/.ahoy.yml "${TESTDIR}"
  ddev start -y >/dev/null
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  # Do something here to verify functioning extra service
  ddev ahoy --version
  ddev ahoy ddev:ahoy
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get hanoii/ddev-ahoy with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get hanoii/ddev-ahoy
  ddev restart >/dev/null
  # Do something useful here that verifies the add-on
  ddev ahoy --version
  ddev ahoy ddev:ahoy
}

