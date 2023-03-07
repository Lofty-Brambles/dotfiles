#!/bin/bash

set -e

cd "$(dirname $0)"/..

find . -name install.zsh | while read installer ; do chmod +x "${installer}"; sh -c "${installer}" ; done