# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for sys-apps/knxd::kripton-overlay"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( knxd )

acct-user_add_deps
