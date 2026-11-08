#!/usr/bin/env bash
# Package what `make all` produced the way this project's own bochsrc says it
# is booted, then read the answer off the emulated machine instead of off the
# compiler's exit status.
#
# bochsrc is literally:  floppaya: 1_44=os-image  /  boot: a
# i.e. os-image (8192 bytes = 1 boot sector + 15 kernel sectors) is only the
# beginning of a 1.44 MiB floppy. QEMU refuses to present a truncated floppy,
# so dd the image into a full one -- the boot sector's INT 0x13 read of
# cylinder 0 / head 0 / sector 2..16 only lands if the drive reports that
# geometry.
set -euo pipefail

IMG=os-image
if [ ! -f "$IMG" ]; then
  echo "::error::make all did not produce $IMG"
  exit 1
fi
echo "os-image      : $(stat -c%s "$IMG") bytes"
echo "boot sector   : $(stat -c%s boot/boot_sector.bin) bytes"
echo "kernel.bin    : $(stat -c%s kernel.bin) bytes (truncate -s 7680 target)"

FLOPPY=/tmp/sc-kernel.floppy
dd if=/dev/zero of="$FLOPPY" bs=1024 count=1440 status=none
dd if="$IMG" of="$FLOPPY" conv=notrunc bs=512 status=none
echo "floppy        : $(stat -c%s "$FLOPPY") bytes -> $FLOPPY"

# The two things that are proved here, and why they are the right things:
#
#   --expect-attr 0f   kernel/kernel.c's prints are all commented out
#                      upstream, so a *blank* screen is the correct outcome --
#                      and a blank screen is also what you get when nothing
#                      runs at all. drivers/screen.c's clear_screen() writes
#                      u16 blank = 0x0F20 into all 2000 cells, so the
#                      attribute byte 0x0F in every cell is the fingerprint
#                      that the C kernel executed (BIOS leaves 0x07).
#   --eip-range        the linked kernel lives at 0x1000 (-Ttext 0x1000);
#                      being parked at 0x1005 = the `jmp $` right after
#                      `call main` returned. See objdump -D kernel.bin.
#   --parked           two `info registers` samples 0.6s apart that agree say
#                      "halted in the idle loop", not "still booting" and not
#                      "crashing in a loop".
python3 edidada-ci/qemu_boot_check.py \
  --image "$FLOPPY" --wait 5 \
  --expect-attr 0f --min-attr-cells 1900 \
  --eip-range 0x1000-0x7000 --parked \
  --out qemu-report.json
