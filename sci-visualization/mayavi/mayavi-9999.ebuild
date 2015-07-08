# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx git-2

DESCRIPTION="Enthought Tool Suite: Scientific data 3-dimensional visualizer"
HOMEPAGE="http://code.enthought.com/projects/mayavi/
	  http://pypi.python.org/pypi/mayavi/"
EGIT_REPO_URI="git://github.com/enthought/${PN}.git
	       https://github.com/enthought/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

RDEPEND="
	>=dev-python/apptools-4[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/envisage-4[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyface[${PYTHON_USEDEP}]
	>=dev-python/traitsui-4[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]"
CDEPEND="sci-libs/vtk[python]"
DEPEND="
	${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/wxpython[opengl]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

#DOCS="docs/*.txt"

# testsuite is a trainwreck; https://github.com/enthought/mayavi/issues/66
#RESTRICT="test"

PATCHES=( "${FILESDIR}"/${PN}-4.2.0-doc.patch )

python_compile_all() {
	if use doc; then
		${PYTHON} setup.py gen_docs || die
		${PYTHON} setup.py build_docs || die
	fi
}

python_test() {

	VIRTUALX_COMMAND="nosetests" virtualmake
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dohtml -r docs/build/mayavi/html/

	if use examples; then
		docompress -x usr/share/doc/${PF}/examples/
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	newicon mayavi/core/ui/images/m2.png mayavi2.png
	make_desktop_entry ${PN}2 \
		"Mayavi2 2D/3D Scientific Visualization" ${PN}2
}
