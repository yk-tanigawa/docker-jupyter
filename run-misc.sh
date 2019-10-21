#!/bin/bash
set -beEuo pipefail

[[ ${DEFAULT_VERSION:-} -eq 1 ]] && return || readonly DEFAULT_VERSION="20191021"

