#!/bin/bash

conf="/opt/appdata/plexguide/rclone.conf"
log="/var/plexguide"


if grep -q "gdrive:" $conf ; then
rclone dedupe gdrive: \
 --dedupe-mode largest \
 --verbose=1 \
 --fast-list \
 --retries 3 \
 --no-update-modtime \
 --user-agent="gdrivededupe" \
 --timeout=30m \
 --config /opt/appdata/plexguide/rclone.conf
fi

if grep -q "tdrive:" $conf ; then
 rclone dedupe tdrive: \
 --dedupe-mode largest \
 --verbose=1 \
 --fast-list \
 --retries 3 \
 --no-update-modtime \
 --user-agent="tdrivededupe" \
 --timeout=30m \
 --config /opt/appdata/plexguide/rclone.conf
fi

if grep -q "gcrypt:" $conf ; then
rclone dedupe gcrypt: \
 --dedupe-mode largest \
 --verbose=1 \
 --fast-list \
 --retries 3 \
 --user-agent="grcyptdedupe" \
 --no-update-modtime \
 --timeout=30m \
 --config /opt/appdata/plexguide/rclone.conf
fi

if grep -q "tcrypt:" $conf ; then
rclone dedupe tcrypt: \
 --dedupe-mode largest \
 --verbose=1 \
 --fast-list \
 --retries 3 \
 --user-agent="tcryptdedupe" \
 --no-update-modtime \
 --timeout=30m \
 --config /opt/appdata/plexguide/rclone.conf
fi
