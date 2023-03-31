package device

type DeviceOption func(d *Device)

func WithCustomIndexTable(t IndexTable) DeviceOption {
	return func(d *Device) {
		d.indexTable = t
	}
}
