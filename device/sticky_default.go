//go:build !linux

package device

import (
	"go.euank.com/wireguard/conn"
	"go.euank.com/wireguard/rwcancel"
)

func (device *Device) startRouteListener(bind conn.Bind) (*rwcancel.RWCancel, error) {
	return nil, nil
}
