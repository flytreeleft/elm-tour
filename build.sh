#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"


DIST_DIR="${DIR}/dist"


rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}"
cp -r "${DIR}/public"/* "${DIST_DIR}"/

data_json="{}"

for file in `find ${DIR} -name package.json -type f`; do
    dir="$(dirname $file)"
    dir_name="$(basename $dir)"
    title="$(cat $dir/README.md | head -n 1)"

    pushd "${dir}"
        echo "Build ${dir_name} ..."

        yarn install \
        && WEB_CONTEXT_ROOT_PATH="/${dir_name}/" yarn prod \
        && mv dist "${DIST_DIR}"/${dir_name} \
        && data_json="${data_json},{\"path\": \"./${dir_name}\", \"title\": \"${title}\"}"
    popd
done

echo "[${data_json}]" > "${DIST_DIR}/data.json"

echo "Done"
