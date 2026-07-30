#!/usr/bin/env bash
# Notarize a ZIP that contains loose Mach-O binaries (e.g. csound.node). After notarytool
# accepts, staple each Mach-O, then re-pack the ZIP.
set -euo pipefail

archive="${1:?usage: $0 path/to/archive.zip}"
enabled="${2:-OFF}"

if [[ "${enabled}" != "ON" ]]; then
  echo "Notarization disabled; skipping."
  exit 0
fi

if [[ ! -f "${archive}" ]]; then
  echo "Archive does not exist: ${archive}" >&2
  exit 1
fi

notary_key_id="${APPLE_NOTARY_KEY_ID:-${APPLE_API_KEY_ID:-}}"
notary_issuer_id="${APPLE_NOTARY_ISSUER_ID:-${APPLE_API_ISSUER_ID:-}}"
notary_key="${APPLE_NOTARY_KEY:-${APPLE_API_KEY_P8_BASE64:-}}"

if [[ -z "${notary_key}" || -z "${notary_key_id}" || -z "${notary_issuer_id}" ]]; then
  echo "Missing notary credentials (APPLE_API_KEY_P8_BASE64 / APPLE_API_KEY_ID / APPLE_API_ISSUER_ID or APPLE_NOTARY_*)." >&2
  exit 1
fi

key_file="$(mktemp -t "AuthKey_${notary_key_id}.XXXXXX.p8")"
stitch_dir=""
cleanup() {
  rm -f "${key_file}"
  if [[ -n "${stitch_dir}" ]]; then
    rm -rf "${stitch_dir}"
  fi
}
trap cleanup EXIT

if [[ -f "${notary_key}" ]]; then
  cp "${notary_key}" "${key_file}"
else
  printf "%s" "${notary_key}" | /usr/bin/base64 --decode > "${key_file}"
fi

echo "Submitting ${archive} for notarization."
xcrun notarytool submit "${archive}" \
  --key "${key_file}" \
  --key-id "${notary_key_id}" \
  --issuer "${notary_issuer_id}" \
  --wait

archive_abs="$(cd "$(dirname "${archive}")" && pwd)/$(basename "${archive}")"
stitch_dir="$(mktemp -d -t staple-nwjs-zip.XXXXXX)"
unzip -q "${archive_abs}" -d "${stitch_dir}"

while IFS= read -r -d '' macho; do
  if file "${macho}" | grep -q "Mach-O"; then
    echo "Stapling ${macho}"
    xcrun stapler staple "${macho}"
  fi
done < <(find "${stitch_dir}" -type f -print0)

echo "Re-packaging ${archive_abs}"
rm -f "${archive_abs}"
( cd "${stitch_dir}" && /usr/bin/zip -q -r -y "${archive_abs}" . )
