BATS_MOCK_TMPDIR="${BATS_TMPDIR}"
BATS_MOCK_BINDIR="${BATS_MOCK_TMPDIR}/bin"

PATH="$BATS_MOCK_BINDIR:$PATH"

stub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  shift

  export "${prefix}_STUB_PLAN"="${BATS_MOCK_TMPDIR}/${program}-stub-plan"
  export "${prefix}_STUB_ARG"="${BATS_MOCK_TMPDIR}/${program}-stub-arg"
  export "${prefix}_STUB_RUN"="${BATS_MOCK_TMPDIR}/${program}-stub-run"
  export "${prefix}_STUB_END"=

  mkdir -p "${BATS_MOCK_BINDIR}"
  ln -sf "${BASH_SOURCE[0]%stub.bash}binstub" "${BATS_MOCK_BINDIR}/${program}"

  touch "${BATS_MOCK_TMPDIR}/${program}-stub-plan"
  for arg in "$@"; do printf "%s\n" "$arg" >> "${BATS_MOCK_TMPDIR}/${program}-stub-plan"; done
}

unstub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  local path="${BATS_MOCK_BINDIR}/${program}"

  export "${prefix}_STUB_END"=1

  local STATUS=0
  "$path" "verify_bats_mock_on_unstub" || STATUS="$?"
  
  local arguments_file="${BATS_MOCK_TMPDIR}/${program}-stub-arg"
  local plan_file="${BATS_MOCK_TMPDIR}/${program}-stub-plan"
  if [ $STATUS -ne 0]; then
      if [ ! -f "$arguments_file" ]; then
          >&2 echo "Program never invoked"
      fi
      >&2 echo "Planned:"
      >&2 cat  "$plan_file"
      >&2 echo "VS Real Invocations:"
      >&2 cat  "$arguments_file"
  fi

  rm -f "$path"
  rm -f "$plan_file"
  rm -f "$arguments_file"
  rm -f "${BATS_MOCK_TMPDIR}/${program}-stub-run"

  return "$STATUS"
}
