# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Pico SDK (C/C++) for RP2040-based devices such as the RaspberryPi Pico"
HOMEPAGE="https://github.com/raspberrypi/${PN}"

# We clone via git since we need to fetch the submodules
EGIT_REPO_URI="${HOMEPAGE}"
EGIT_COMMIT="${PV}"
EGIT_SUBMODULES=( tinyusb lib/tinyusb/tools/uf2 lib/tinyusb/lib/lwip )

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	# Not sure if /opt is the best place but it's mainly
	# "source code" for an embedded system, not for the host
	dodir /opt/raspberrypi/${PN}
	# Remove all .git folders (including in submodules)
	# Drop output since there are some "folder not found" errors I don't understand
	find "${S}" -type d -name ".git" -exec rm -rf '{}' \; > /dev/null 2> /dev/null
	# Copy over everything not yet deleted
	cp -R "${S}/" "${D}/opt/raspberrypi/" || die "Install failed!"
}