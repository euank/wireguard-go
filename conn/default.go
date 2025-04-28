//go:build !windows

/* SPDX-License-Identifier: MIT
 *
 * Copyright (C) 2017-2023 WireGuard LLC. All Rights Reserved.
 */

package conn

import "log/slog"

func NewDefaultBind() Bind { return NewStdNetBind(slog.Default()) }
