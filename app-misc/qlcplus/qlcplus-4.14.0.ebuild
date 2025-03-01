# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev virtualx xdg

DESCRIPTION="A software to control DMX or analog lighting systems"
HOMEPAGE="https://www.qlcplus.org/"
SRC_URI="https://github.com/mcallegari/${PN}/archive/QLC+_${PV}.tar.gz"
S="${WORKDIR}/qlcplus-QLC-_${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/qttools:5
"
RDEPEND="
	dev-embedded/libftdi:1
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtdeclarative:6
	dev-qt/qtserialport:6
	media-libs/alsa-lib
	media-libs/libmad
	media-libs/libsndfile
	sci-libs/fftw:3.0=
	virtual/libusb:1
	virtual/udev
"
IDEPEND="
	dev-util/desktop-file-utils
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default

	sed -e "s|lib/${CMAKE_C_LIBRARY_ARCHITECTURE}|$(get_libdir)|g" \
		-i variables.cmake || die

	# TODO: Is hardcoding the path fine?
	sed -e "s|/etc/udev/rules.d|$(get_udevdir)|g" \
		-i variables.cmake || die

	cmake_src_prepare
}

src_configure() {
        local mycmakeargs=(
        )
        # -DWITH_TESTS option works only with debug build, needs to be set here
        # to not be overriden by cmake.eclass
        CMAKE_BUILD_TYPE=Release cmake_src_configure
}

#src_install() {
#	emake INSTALL_ROOT="${D}" install
#}

pkg_postinst() {
	udev_reload

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

src_test() {
	virtx cmake_build check
}

pkg_postrm() {
	udev_reload

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
