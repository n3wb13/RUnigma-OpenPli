#!/bin/bash

# originally created by schischu and konfetti
# fedora parts prepared by lareq
# fedora/suse/ubuntu scripts merged by kire pudsje (kpc)

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root (sudo $0)" 1>&2
	exit 1
fi

# make sure defines have not already been defined
UBUNTU=
FEDORA=
SUSE=

# Try to detect the distribution
if `which lsb_release > /dev/null 2>&1`; then 
	case `lsb_release -s -i` in
		Debian*) UBUNTU=1; INSTALL="apt-get -y install";;
		Fedora*) FEDORA=1; INSTALL="yum install -y";;
		SUSE*)   SUSE=1;   INSTALL="zypper install -y";;
		Ubuntu*) UBUNTU=1; INSTALL="apt-get -y install";;
	esac
fi

# Not detected by lsb_release, try release files
if [ -z "$FEDORA$SUSE$UBUNTU" ]; then
	if   [ -f /etc/redhat-release ]; then FEDORA=1; INSTALL="yum install -y"; 
	elif [ -f /etc/fedora-release ]; then FEDORA=1; INSTALL="yum install -y"; 
	elif [ -f /etc/SuSE-release ];   then SUSE=1;   INSTALL="zypper install -y";
	elif [ -f /etc/debian_version ]; then UBUNTU=1; INSTALL="apt-get -y install";
	fi
fi

# still not detected, display error and let the user manually install
if [ -z "$FEDORA$SUSE$UBUNTU" ]; then
	echo
	echo "Cannot determine which OS distribution you use," 
	echo "or your distribution is not (yet) supported." 
	echo "Please report this fact in the AAF or Kathi-forums"
	echo
	echo "Try installing the following packages: "
	# determine probable distribution, based on package system, 
	# Suse should be last because the others may also have rpm installed.
	{ `which apt-get > /dev/null 2>&1` && UBUNTU=1; } || \
	{ `which yum     > /dev/null 2>&1` && FEDORA=1; } || \
	SUSE=2
	INSTALL="echo "
fi

PACKAGES="\
	subversion \
	ccache \
	flex \
	bison \
	texinfo \
	libtool \
	swig \
	dialog \
	wget \
	${UBUNTU:+rpm}                                    ${FEDORA:+rpm-build} \
	${UBUNTU:+lsb-release}     ${SUSE:+lsb-release}   ${FEDORA:+redhat-lsb} \
	${UBUNTU:+git-core}        ${SUSE:+git-core}      ${FEDORA:+git} \
	${UBUNTU:+libncurses5-dev} ${SUSE:+ncurses-devel} ${FEDORA:+ncurses-devel} \
	${UBUNTU:+gettext}         ${SUSE:+gettext-devel} ${FEDORA:+gettext-devel}  \
	${UBUNTU:+zlib1g-dev}      ${SUSE:+zlib-devel}    ${FEDORA:+zlib-devel} \
	${UBUNTU:+g++}             ${SUSE:+gcc gcc-c++}   ${FEDORA:+gcc-c++} \
	${UBUNTU:+automake}        ${SUSE:+automake make} \
	${UBUNTU:+xfslibs-dev}     ${SUSE:+xfsprogs-devel} \
	${UBUNTU:+pkg-config}      ${SUSE:+pkg-config}    \
	                           ${SUSE:+patch} \
	${UBUNTU:+cfv} \
	${UBUNTU:+fakeroot} \
	${UBUNTU:+gawk} \
";

$INSTALL $PACKAGES

# Link sh to bash instead of dash on Ubuntu (and possibly others)
/bin/sh --version 2>/dev/null | grep bash -s -q
if [ ! "$?" -eq "0" ]; then
	echo
	read -p "/bin/sh should link to /bin/bash, adjust it (Y/n)? "
	if [ -z "$REPLY" -o "$REPLY" == "Y" -o "$REPLY" == "y" ]; then
		rm -f /bin/sh
		ln -s /bin/bash /bin/sh
	fi
fi
