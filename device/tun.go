/* SPDX-License-Identifier: MIT
 *
 * Copyright (C) 2017-2023 WireGuard LLC. All Rights Reserved.
 */

package device

import (
	"context"

	"go.euank.com/wireguard/tun"
)

const DefaultMTU = 1420

func (device *Device) RoutineTUNEventReader(ctx context.Context) {
	device.log.Debug("routine: event worker - started")

	for event := range device.tun.device.Events() {
		if event&tun.EventMTUUpdate != 0 {
			mtu, err := device.tun.device.MTU()
			if err != nil {
				device.log.Error("failed to load updated MTU of device", "err", err)
				continue
			}
			if mtu < 0 {
				device.log.Error("MTU not updated to negative value", "err", mtu)
				continue
			}
			var tooLarge bool
			if mtu > MaxContentSize {
				tooLarge = true
				mtu = MaxContentSize
			}
			old := device.tun.mtu.Swap(int32(mtu))
			if int(old) != mtu {
				if tooLarge {
					device.log.Debug("MTU updated", "mtu", mtu, "old", old, "cappedAt", MaxContentSize)
				} else {
					device.log.Debug("MTU updated", "mtu", mtu, "old", old)
				}
			}
		}

		if event&tun.EventUp != 0 {
			device.log.Debug("interface up requested")
			device.Up(ctx)
		}

		if event&tun.EventDown != 0 {
			device.log.Debug("interface down requested")
			device.Down(ctx)
		}
	}

	device.log.Debug("routine: event worker - stopped")
}
