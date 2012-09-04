#
#bzip2
#
DESCRIPTION_bzip2 = "bzip2"

FILES_bzip2 = \
/usr/bin/* \
/usr/lib/*

$(DEPDIR)/bzip2.do_prepare: bootstrap @DEPENDS_bzip2@
	@PREPARE_bzip2@
	touch $@

$(DEPDIR)/bzip2.do_compile: $(DEPDIR)/bzip2.do_prepare
	cd @DIR_bzip2@ && \
		mv Makefile-libbz2_so Makefile && \
		$(MAKE) all CC=$(target)-gcc
	touch $@

$(DEPDIR)/min-bzip2 $(DEPDIR)/std-bzip2 $(DEPDIR)/max-bzip2 \
$(DEPDIR)/bzip2: \
$(DEPDIR)/%bzip2: $(DEPDIR)/bzip2.do_compile
	$(start_build)
	cd @DIR_bzip2@ && \
		@INSTALL_bzip2@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_bzip2@
	[ "x$*" = "x" ] && touch $@ || true

#
# MODULE-INIT-TOOLS
#
$(DEPDIR)/module_init_tools.do_prepare: bootstrap @DEPENDS_module_init_tools@
	@PREPARE_module_init_tools@
	touch $@

$(DEPDIR)/module_init_tools.do_compile: $(DEPDIR)/module_init_tools.do_prepare
	cd @DIR_module_init_tools@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-module_init_tools $(DEPDIR)/std-module_init_tools $(DEPDIR)/max-module_init_tools \
$(DEPDIR)/module_init_tools: \
$(DEPDIR)/%module_init_tools: $(DEPDIR)/%lsb $(MODULE_INIT_TOOLS:%=root/etc/%) $(DEPDIR)/module_init_tools.do_compile
	cd @DIR_module_init_tools@ && \
		@INSTALL_module_init_tools@
	$(call adapted-etc-files,$(MODULE_INIT_TOOLS_ADAPTED_ETC_FILES))
	$(call initdconfig,module-init-tools)
#	@DISTCLEANUP_module_init_tools@
	[ "x$*" = "x" ] && touch $@ || true

#
# GREP
#
DESCRIPTION_grep = "grep"

FILES_grep = \
/usr/bin/grep

$(DEPDIR)/grep.do_prepare: bootstrap @DEPENDS_grep@
	@PREPARE_grep@
	cd @DIR_grep@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch
	touch $@

$(DEPDIR)/grep.do_compile: $(DEPDIR)/grep.do_prepare
	cd @DIR_grep@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-nls \
			--disable-perl-regexp \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-grep $(DEPDIR)/std-grep $(DEPDIR)/max-grep \
$(DEPDIR)/grep: \
$(DEPDIR)/%grep: $(DEPDIR)/grep.do_compile
	$(start_build)
	cd @DIR_grep@ && \
		@INSTALL_grep@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_grep@
	[ "x$*" = "x" ] && touch $@ || true

#
# PPPD
#
DESCRIPTION_pppd = "pppd"
FILES_pppd = \
/sbin/* \
/lib/modules/*.so

$(DEPDIR)/pppd.do_prepare: bootstrap @DEPENDS_pppd@
	@PREPARE_pppd@
	cd @DIR_pppd@ && \
		sed -ie s:/usr/include/pcap-bpf.h:$(prefix)/cdkroot/usr/include/pcap-bpf.h: pppd/Makefile.linux && \
		patch -p1 < ../Patches/pppd.patch
	touch $@

$(DEPDIR)/pppd.do_compile: pppd.do_prepare
	cd @DIR_pppd@  && \
		$(BUILDENV) \
	      CFLAGS="$(TARGET_CFLAGS) -I$(buildprefix)/linux/arch/sh" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--with-kernel=$(buildprefix)/$(KERNEL_DIR) \
			--disable-kernel-module \
			--prefix=/usr && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-pppd $(DEPDIR)/std-pppd $(DEPDIR)/max-pppd \
$(DEPDIR)/pppd: \
$(DEPDIR)/%pppd: $(DEPDIR)/pppd.do_compile
	$(start_build)
	cd @DIR_pppd@  && \
		@INSTALL_pppd@
	$(tocdk_build)
	mkdir $(PKDIR)/lib/modules/
	mv -f $(PKDIR)/lib/pppd/2.4.5/*.so $(PKDIR)/lib/modules/
	$(toflash_build)
#	@DISTCLEANUP_pppd@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
#
# USB MODESWITCH
#
DESCRIPTION_usb_modeswitch = usb_modeswitch
RDEPENDS_usb_modeswitch = libusb usb_modeswitch_data
FILES_usb_modeswitch = \
/etc/* \
/lib/udev/* \
/usr/sbin/*

$(DEPDIR)/usb_modeswitch.do_prepare: @DEPENDS_usb_modeswitch@ $(RDEPENDS_usb_modeswitch)
	@PREPARE_usb_modeswitch@
	touch $@
$(DEPDIR)/usb_modeswitch.do_compile: $(DEPDIR)/usb_modeswitch.do_prepare
	  touch $@

$(DEPDIR)/usb_modeswitch: \
$(DEPDIR)/%usb_modeswitch: $(DEPDIR)/usb_modeswitch.do_compile
	$(start_build)
	cd @DIR_usb_modeswitch@  && \
	  $(BUILDENV) \
		DESTDIR=$(PKDIR) \
		PREFIX=$(PKDIR)/usr \
	  $(MAKE) $(MAKE_OPTS) install
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_usb_modeswitch@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# USB MODESWITCH DATA
#
DESCRIPTION_usb_modeswitch_data = usb_modeswitch_data

FILES_usb_modeswitch_data = \
/usr/* \
/etc/* \
/lib/udev/rules.d

$(DEPDIR)/usb_modeswitch_data.do_prepare: @DEPENDS_usb_modeswitch_data@
	@PREPARE_usb_modeswitch_data@
	touch $@
	
$(DEPDIR)/usb_modeswitch_data.do_compile: $(DEPDIR)/usb_modeswitch_data.do_prepare
	touch $@

$(DEPDIR)/usb_modeswitch_data: \
$(DEPDIR)/%usb_modeswitch_data: $(DEPDIR)/usb_modeswitch_data.do_compile
	$(start_build)
	cd @DIR_usb_modeswitch_data@  && \
		$(BUILDENV) \
		DESTDIR=$(PKDIR) \
		$(MAKE) install
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_usb_modeswitch_data@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
#
# NTFS-3G
#
DESCRIPTION_ntfs_3g = ntfs-3g
RDEPENDS_ntfs_3g = fuse
FILES_ntfs_3g = \
/bin/ntfs-3g \
/sbin/mount.ntfs-3g \
/usr/lib/* \
/lib/*

$(DEPDIR)/ntfs_3g.do_prepare: @DEPENDS_ntfs_3g@
	@PREPARE_ntfs_3g@
	touch $@

$(DEPDIR)/ntfs_3g.do_compile: bootstrap fuse $(DEPDIR)/ntfs_3g.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	LDCONFIG=$(prefix)/cdkroot/sbin/ldconfig \
	cd @DIR_ntfs_3g@  && \
		$(BUILDENV) \
		PKG_CONFIG=$(hostprefix)/bin/pkg-config \
		./configure \
			--build=$(build) \
			--disable-ldconfig \
			--host=$(target) \
			--prefix=/usr
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-ntfs_3g $(DEPDIR)/std-ntfs_3g $(DEPDIR)/max-ntfs_3g \
$(DEPDIR)/ntfs_3g: \
$(DEPDIR)/%ntfs_3g: $(DEPDIR)/ntfs_3g.do_compile
	$(start_build)
	cd @DIR_ntfs_3g@  && \
		@INSTALL_ntfs_3g@
	$(tocdk_build)	
	$(toflash_build)
#	@DISTCLEANUP_ntfs_3g@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# LSB
#
DESCRIPTION_lsb = "lsb"
FILES_lsb = \
/lib/lsb/*

$(DEPDIR)/lsb.do_prepare: bootstrap @DEPENDS_lsb@
	@PREPARE_lsb@
	touch $@

$(DEPDIR)/lsb.do_compile: $(DEPDIR)/lsb.do_prepare
	touch $@

$(DEPDIR)/min-lsb $(DEPDIR)/std-lsb $(DEPDIR)/max-lsb \
$(DEPDIR)/lsb: \
$(DEPDIR)/%lsb: $(DEPDIR)/lsb.do_compile
	$(start_build)
	cd @DIR_lsb@ && \
		@INSTALL_lsb@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_lsb@
	[ "x$*" = "x" ] && touch $@ || true

#
# PORTMAP
#
DESCRIPTION_portmap = "the program supports access control in the style of the tcp wrapper (log_tcp) packag"
FILES_portmap = \
/sbin/* \
/etc/init.d/

$(DEPDIR)/portmap.do_prepare: bootstrap @DEPENDS_portmap@
	@PREPARE_portmap@
	cd @DIR_portmap@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: S 41 10\n### BEGIN INIT INFO/g' -i debian/init.d
	touch $@

$(DEPDIR)/portmap.do_compile: $(DEPDIR)/portmap.do_prepare
	cd @DIR_portmap@ && \
		$(BUILDENV) \
		$(MAKE)
	touch $@

$(DEPDIR)/min-portmap $(DEPDIR)/std-portmap $(DEPDIR)/max-portmap \
$(DEPDIR)/portmap: \
$(DEPDIR)/%portmap: $(DEPDIR)/%lsb $(PORTMAP_ADAPTED_ETC_FILES:%=root/etc/%) $(DEPDIR)/portmap.do_compile
	$(start_build)
	mkdir -p $(PKDIR)/sbin/
	mkdir -p $(PKDIR)/etc/init.d/
	mkdir -p $(PKDIR)/usr/share/man/man8
	cd @DIR_portmap@ && \
		@INSTALL_portmap@
	$(call adapted-etc-files,$(PORTMAP_ADAPTED_ETC_FILES))
	$(call initdconfig,portmap)
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_portmap@
	[ "x$*" = "x" ] && touch $@ || true

#
# OPENRDATE
#
$(DEPDIR)/openrdate.do_prepare: bootstrap @DEPENDS_openrdate@
	@PREPARE_openrdate@
	cd @DIR_openrdate@
	touch $@

$(DEPDIR)/openrdate.do_compile: $(DEPDIR)/openrdate.do_prepare
	cd @DIR_openrdate@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/min-openrdate $(DEPDIR)/std-openrdate $(DEPDIR)/max-openrdate \
$(DEPDIR)/openrdate: \
$(DEPDIR)/%openrdate: $(OPENRDATE_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(DEPDIR)/openrdate.do_compile
	cd @DIR_openrdate@ && \
		@INSTALL_openrdate@
	( cd root/etc && for i in $(OPENRDATE_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in rdate.sh ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
#	@DISTCLEANUP_openrdate@
	[ "x$*" = "x" ] && touch $@ || true

#
# E2FSPROGS
#
DESCRIPTION_e2fsprogs = "e2fsprogs"
FILES_e2fsprogs = \
/sbin/e2fsck \
/sbin/fsck \
/sbin/fsck* \
/sbin/mkfs* \
/sbin/mke2fs \
/sbin/tune2fs \
/usr/lib/e2initrd_helper \
/lib/*.so* \
/usr/lib/*.so

$(DEPDIR)/e2fsprogs.do_prepare: bootstrap @DEPENDS_e2fsprogs@
	@PREPARE_e2fsprogs@
	touch $@

if STM24
$(DEPDIR)/e2fsprogs.do_compile: $(DEPDIR)/e2fsprogs.do_prepare | $(UTIL_LINUX)
	cd @DIR_e2fsprogs@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	cc=$(target)-gcc \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--target=$(target) \
		--with-linker=$(target)-ld \
		--enable-e2initrd-helper \
		--enable-compression \
		--disable-uuidd \
		--disable-rpath \
		--disable-quota \
		--disable-defrag \
		--disable-nls \
		--disable-libuuid \
		--disable-libblkid \
		--enable-elf-shlibs \
		--enable-verbose-makecmds \
		--enable-symlink-install \
		--without-libintl-prefix \
		--without-libiconv-prefix \
		--with-root-prefix= && \
	$(MAKE) all && \
	$(MAKE) -C e2fsck e2fsck.static
	touch $@
else !STM24
$(DEPDIR)/e2fsprogs.do_compile: $(DEPDIR)/e2fsprogs.do_prepare
	cd @DIR_e2fsprogs@ && \
	$(BUILDENV) \
	cc=$(target)-gcc \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--target=$(target) \
		--with-linker=$(target)-ld \
		--enable-htree \
		--disable-profile \
		--disable-e2initrd-helper \
		--disable-swapfs \
		--disable-debugfs \
		--disable-imager \
		--enable-resizer \
		--enable-dynamic-e2fsck \
		--enable-fsck \
		--with-gnu-ld \
		--disable-nls \
		--prefix=/usr \
		--enable-elf-shlibs \
		--enable-dynamic-e2fsck \
		--disable-evms \
		--with-root-prefix= && \
		$(MAKE) libs progs
	touch $@
endif !STM24

if STM24
$(DEPDIR)/e2fsprogs: $(DEPDIR)/e2fsprogs.do_compile
	$(start_build)
	cd @DIR_e2fsprogs@ && \
	$(BUILDENV) \
	$(MAKE) install install-libs \
		LDCONFIG=true \
		DESTDIR=$(PKDIR) && \
	$(INSTALL) e2fsck/e2fsck.static $(PKDIR)/sbin
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_e2fsprogs@
	touch $@
else !STM24
$(DEPDIR)/min-e2fsprogs $(DEPDIR)/std-e2fsprogs $(DEPDIR)/max-e2fsprogs \
$(DEPDIR)/e2fsprogs: \
$(DEPDIR)/%e2fsprogs: $(DEPDIR)/e2fsprogs.do_compile
	$(start_build)
	cd @DIR_e2fsprogs@ && \
		@INSTALL_e2fsprogs@
	[ "x$*" = "x" ] && ( cd @DIR_e2fsprogs@ && \
		$(MAKE) install -C lib/uuid DESTDIR=$(PKDIR) && \
		$(MAKE) install -C lib/blkid DESTDIR=$(PKDIR) ) || true
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_e2fsprogs@
	[ "x$*" = "x" ] && touch $@ || true
endif !STM24

#
# XFSPROGS
#
DESCRIPTION_xfsprogs = "xfsprogs"

FILES_xfsprogs = \
/bin/*

$(DEPDIR)/xfsprogs.do_prepare: bootstrap $(DEPDIR)/e2fsprogs $(DEPDIR)/libreadline @DEPENDS_xfsprogs@
	@PREPARE_xfsprogs@
	touch $@

$(DEPDIR)/xfsprogs.do_compile: $(DEPDIR)/xfsprogs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_xfsprogs@ && \
		export DEBUG=-DNDEBUG && export OPTIMIZER=-O2 && \
		mv -f aclocal.m4 aclocal.m4.orig && mv Makefile Makefile.sgi || true && chmod 644 Makefile.sgi && \
		aclocal -I m4 -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix= \
			--enable-shared=yes \
			--enable-gettext=yes \
			--enable-readline=yes \
			--enable-editline=no \
			--enable-termcap=yes && \
		cp -p Makefile.sgi Makefile && export top_builddir=`pwd` && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-xfsprogs $(DEPDIR)/std-xfsprogs $(DEPDIR)/max-xfsprogs \
$(DEPDIR)/xfsprogs: \
$(DEPDIR)/%xfsprogs: $(DEPDIR)/xfsprogs.do_compile
	$(start_build)
	cd @DIR_xfsprogs@ && \
		export top_builddir=`pwd` && \
		@INSTALL_xfsprogs@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_xfsprogs@
	[ "x$*" = "x" ] && touch $@ || true

#
# MC
#
DESCRIPTION_mc = "Midnight Commander"

FILES_mc = \
/usr/bin/* \
/usr/etc/mc/* \
/usr/libexec/mc/extfs.d/* \
/usr/libexec/mc/fish/*

$(DEPDIR)/mc.do_prepare: bootstrap glib2 @DEPENDS_mc@
	@PREPARE_mc@
	touch $@

$(DEPDIR)/mc.do_compile: $(DEPDIR)/mc.do_prepare | $(NCURSES_DEV)
	cd @DIR_mc@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-gpm-mouse \
			--with-screen=ncurses \
			--without-x && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-mc $(DEPDIR)/std-mc $(DEPDIR)/max-mc \
$(DEPDIR)/mc: \
$(DEPDIR)/%mc: %glib2 $(DEPDIR)/mc.do_compile
	$(start_build)
	cd @DIR_mc@ && \
		@INSTALL_mc@
	$(tocdk_build)
	$(toflash_build)
#		export top_builddir=`pwd` && \
#		$(MAKE) install DESTDIR=$(prefix)/$*cdkroot
#	@DISTCLEANUP_mc@
	[ "x$*" = "x" ] && touch $@ || true

#
# SDPARM
#
DESCRIPTION_sdparm = "sdparm"

FILES_sdparm = \
/sbin/sdparm

$(DEPDIR)/sdparm.do_prepare: bootstrap @DEPENDS_sdparm@
	@PREPARE_sdparm@
	touch $@

$(DEPDIR)/sdparm.do_compile: $(DEPDIR)/sdparm.do_prepare
	cd @DIR_sdparm@ && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) clean || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-sdparm $(DEPDIR)/std-sdparm $(DEPDIR)/max-sdparm \
$(DEPDIR)/sdparm: \
$(DEPDIR)/%sdparm: $(DEPDIR)/sdparm.do_compile
	$(start_build)
	mkdir $(PKDIR)/sbin
	cd @DIR_sdparm@ && \
		export PATH=$(MAKE_PATH) && \
		@INSTALL_sdparm@
	$(tocdk_build)
	mv -f $(PKDIR)/usr/bin/sdparm $(PKDIR)/sbin
	$(toflash_build)
#	@DISTCLEANUP_sdparm@
	[ "x$*" = "x" ] && touch $@ || true

#
# SG3_UTILS
#
$(DEPDIR)/sg3_utils.do_prepare: bootstrap @DEPENDS_sg3_utils@
	@PREPARE_sg3_utils@
	touch $@

$(DEPDIR)/sg3_utils.do_compile: $(DEPDIR)/sg3_utils.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sg3_utils@ && \
		$(MAKE) clean || true && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		automake --add-missing --foreign && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-sg3_utils $(DEPDIR)/std-sg3_utils $(DEPDIR)/max-sg3_utils \
$(DEPDIR)/sg3_utils: \
$(DEPDIR)/%sg3_utils: $(DEPDIR)/sg3_utils.do_compile
	cd @DIR_sg3_utils@ && \
		export PATH=$(MAKE_PATH) && \
		@INSTALL_sg3_utils@
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/sbin && \
	( cd root/etc && for i in $(SG3_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	$(INSTALL) -m755 root/usr/sbin/sg_down.sh $(prefix)/$*cdkroot/usr/sbin
#	@DISTCLEANUP_sg3_utils@
	[ "x$*" = "x" ] && touch $@ || true

#
# IPKG
#
$(DEPDIR)/ipkg.do_prepare: bootstrap @DEPENDS_ipkg@
	@PREPARE_ipkg@
	touch $@

$(DEPDIR)/ipkg.do_compile: $(DEPDIR)/ipkg.do_prepare
	cd @DIR_ipkg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-ipkg $(DEPDIR)/std-ipkg $(DEPDIR)/max-ipkg \
$(DEPDIR)/ipkg: \
$(DEPDIR)/%ipkg: $(DEPDIR)/ipkg.do_compile
	cd @DIR_ipkg@ && \
		@INSTALL_ipkg@
	ln -sf ipkg-cl $(prefix)/$*cdkroot/usr/bin/ipkg && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc && $(INSTALL) -m 644 root/etc/ipkg.conf $(prefix)/$*cdkroot/etc && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/ipkg
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/lib/ipkg
	$(INSTALL) -m 644 root/usr/lib/ipkg/status.initial $(prefix)/$*cdkroot/usr/lib/ipkg/status
#	@DISTCLEANUP_ipkg@
	[ "x$*" = "x" ] && touch $@ || true

#
# ZD1211
#
CONFIG_ZD1211B :=
$(DEPDIR)/zd1211.do_prepare: bootstrap @DEPENDS_zd1211@
	@PREPARE_zd1211@
	touch $@

$(DEPDIR)/zd1211.do_compile: $(DEPDIR)/zd1211.do_prepare
	cd @DIR_zd1211@ && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			ZD1211B=$(ZD1211B) \
			CROSS_COMPILE=$(target)- ARCH=sh
	touch $@

#$(DEPDIR)/min-zd1211 $(DEPDIR)/std-zd1211 $(DEPDIR)/max-zd1211 \
#
$(DEPDIR)/zd1211: \
$(DEPDIR)/%zd1211: $(DEPDIR)/zd1211.do_compile
	cd @DIR_zd1211@ && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			BIN_DEST=$(targetprefix)/bin \
			INSTALL_MOD_PATH=$(targetprefix) \
			install
	$(DEPMOD) -ae -b $(targetprefix) -r $(KERNELVERSION)
#	@DISTCLEANUP_zd1211@
	[ "x$*" = "x" ] && touch $@ || true

#
# NANO
#
$(DEPDIR)/nano.do_prepare: bootstrap ncurses ncurses-dev @DEPENDS_nano@
	@PREPARE_nano@
	touch $@

$(DEPDIR)/nano.do_compile: $(DEPDIR)/nano.do_prepare
	cd @DIR_nano@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-nls \
			--enable-tiny \
			--enable-color && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-nano $(DEPDIR)/std-nano $(DEPDIR)/max-nano \
$(DEPDIR)/nano: \
$(DEPDIR)/%nano: $(DEPDIR)/nano.do_compile
	cd @DIR_nano@ && \
		@INSTALL_nano@
#	@DISTCLEANUP_nano@
	[ "x$*" = "x" ] && touch $@ || true

#
# RSYNC
#
$(DEPDIR)/rsync.do_prepare: bootstrap @DEPENDS_rsync@
	@PREPARE_rsync@
	touch $@

$(DEPDIR)/rsync.do_compile: $(DEPDIR)/rsync.do_prepare
	cd @DIR_rsync@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debug \
			--disable-locale && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-rsync $(DEPDIR)/std-rsync $(DEPDIR)/max-rsync \
$(DEPDIR)/rsync: \
$(DEPDIR)/%rsync: $(DEPDIR)/rsync.do_compile
	cd @DIR_rsync@ && \
		@INSTALL_rsync@
#	@DISTCLEANUP_rsync@
	[ "x$*" = "x" ] && touch $@ || true

#
# RFKILL
#
DESCRIPTION_rfkill = rfkill is a small tool to query the state of the rfkill switches, buttons and subsystem interfaces
FILES_rfkill = \
/usr/sbin/*

$(DEPDIR)/rfkill.do_prepare: bootstrap @DEPENDS_rfkill@
	@PREPARE_rfkill@
	touch $@

$(DEPDIR)/rfkill.do_compile: $(DEPDIR)/rfkill.do_prepare
	cd @DIR_rfkill@ && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-rfkill $(DEPDIR)/std-rfkill $(DEPDIR)/max-rfkill \
$(DEPDIR)/rfkill: \
$(DEPDIR)/%rfkill: $(DEPDIR)/rfkill.do_compile
	$(start_build)
	cd @DIR_rfkill@ && \
		@INSTALL_rfkill@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_rfkill@
	[ "x$*" = "x" ] && touch $@ || true

#
# LM_SENSORS
#
DESCRIPTION_lm_sensors = "lm_sensors"

FILES_lm_sensors = \
/usr/bin/sensors \
/etc/sensors.conf \
/usr/lib/*.so* \
/usr/sbin/*

$(DEPDIR)/lm_sensors.do_prepare: bootstrap @DEPENDS_lm_sensors@
	@PREPARE_lm_sensors@
	touch $@

$(DEPDIR)/lm_sensors.do_compile: $(DEPDIR)/lm_sensors.do_prepare
	cd @DIR_lm_sensors@ && \
		$(MAKE) $(MAKE_OPTS) MACHINE=sh PREFIX=/usr user
	touch $@

$(DEPDIR)/min-lm_sensors $(DEPDIR)/std-lm_sensors $(DEPDIR)/max-lm_sensors \
$(DEPDIR)/lm_sensors: \
$(DEPDIR)/%lm_sensors: $(DEPDIR)/lm_sensors.do_compile
	$(start_build)
	cd @DIR_lm_sensors@ && \
		@INSTALL_lm_sensors@ && \
		rm $(PKDIR)/usr/bin/*.pl && \
		rm $(PKDIR)/usr/sbin/*.pl && \
		rm $(PKDIR)/usr/sbin/sensors-detect && \
		rm $(PKDIR)/usr/share/man/man8/sensors-detect.8 && \
		rm $(PKDIR)/usr/include/linux/i2c-dev.h && \
		rm $(PKDIR)/usr/bin/ddcmon
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_lm_sensors@
	[ "x$*" = "x" ] && touch $@ || true

#
# FUSE
#
DESCRIPTION_fuse = "With FUSE it is possible to implement a fully functional filesystem in a userspace program.  Features include:"

FILES_fuse = \
/usr/lib/*.so* \
/etc/init.d/* \
/etc/udev/* \
Usr/bin/*

$(DEPDIR)/fuse.do_prepare: bootstrap curl glib2 @DEPENDS_fuse@
	@PREPARE_fuse@
	touch $@

$(DEPDIR)/fuse.do_compile: $(DEPDIR)/fuse.do_prepare
	cd @DIR_fuse@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -I$(buildprefix)/linux/arch/sh" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--with-kernel=$(buildprefix)/$(KERNEL_DIR) \
			--disable-kernel-module \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-fuse $(DEPDIR)/std-fuse $(DEPDIR)/max-fuse \
$(DEPDIR)/fuse: \
$(DEPDIR)/%fuse: %curl %glib2 $(DEPDIR)/fuse.do_compile
	  $(start_build)
	  cd @DIR_fuse@ && \
		@INSTALL_fuse@
	-rm $(prefix)/$*cdkroot/etc/udev/rules.d/99-fuse.rules
	-rmdir $(prefix)/$*cdkroot/etc/udev/rules.d
	-rmdir $(prefix)/$*cdkroot/etc/udev
	$(LN_SF) sh4-linux-fusermount $(prefix)/$*cdkroot/usr/bin/fusermount
	$(LN_SF) sh4-linux-ulockmgr_server $(prefix)/$*cdkroot/usr/bin/ulockmgr_server
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in fuse ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_fuse@
	[ "x$*" = "x" ] && touch $@ || true

#
# CURLFTPFS
#
$(DEPDIR)/curlftpfs.do_prepare: bootstrap fuse @DEPENDS_curlftpfs@
	@PREPARE_curlftpfs@
	touch $@

$(DEPDIR)/curlftpfs.do_compile: $(DEPDIR)/curlftpfs.do_prepare
	cd @DIR_curlftpfs@ && \
		export ac_cv_func_malloc_0_nonnull=yes && \
		export ac_cv_func_realloc_0_nonnull=yes && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/min-curlftpfs $(DEPDIR)/std-curlftpfs $(DEPDIR)/max-curlftpfs \
$(DEPDIR)/curlftpfs: \
$(DEPDIR)/%curlftpfs: %fuse $(DEPDIR)/curlftpfs.do_compile
	cd @DIR_curlftpfs@ && \
		@INSTALL_curlftpfs@
#	@DISTCLEANUP_curlftpfs@
	[ "x$*" = "x" ] && touch $@ || true

#
# FBSET
#
$(DEPDIR)/fbset.do_prepare: bootstrap @DEPENDS_fbset@
	@PREPARE_fbset@
	touch $@

$(DEPDIR)/fbset.do_compile: $(DEPDIR)/fbset.do_prepare
	cd @DIR_fbset@ && \
		make CC="$(target)-gcc -Wall -O2 -I."
	touch $@

$(DEPDIR)/min-fbset $(DEPDIR)/std-fbset $(DEPDIR)/max-fbset \
$(DEPDIR)/fbset: \
$(DEPDIR)/%fbset: fbset.do_compile
	cd @DIR_fbset@ && \
		@INSTALL_fbset@
#	@DISTCLEANUP_fbset@
	[ "x$*" = "x" ] && touch $@ || true

#
# PNGQUANT
#
$(DEPDIR)/pngquant.do_prepare: bootstrap libz libpng @DEPENDS_pngquant@
	@PREPARE_pngquant@
	touch $@

$(DEPDIR)/pngquant.do_compile: $(DEPDIR)/pngquant.do_prepare
	cd @DIR_pngquant@ && \
		$(target)-gcc -O3 -Wall -I. -funroll-loops -fomit-frame-pointer -o pngquant pngquant.c rwpng.c -lpng -lz -lm
	touch $@

$(DEPDIR)/min-pngquant $(DEPDIR)/std-pngquant $(DEPDIR)/max-pngquant \
$(DEPDIR)/pngquant: \
$(DEPDIR)/%pngquant: $(DEPDIR)/pngquant.do_compile
	cd @DIR_pngquant@ && \
		@INSTALL_pngquant@
#	@DISTCLEANUP_pngquant@
	[ "x$*" = "x" ] && touch $@ || true

#
# MPLAYER
#
$(DEPDIR)/mplayer.do_prepare: bootstrap @DEPENDS_mplayer@
	@PREPARE_mplayer@
	touch $@

$(DEPDIR)/mplayer.do_compile: $(DEPDIR)/mplayer.do_prepare
	cd @DIR_mplayer@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-mencoder && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/min-mplayer $(DEPDIR)/std-mplayer $(DEPDIR)/max-mplayer \
$(DEPDIR)/mplayer: \
$(DEPDIR)/%mplayer: $(DEPDIR)/mplayer.do_compile
	cd @DIR_mplayer@ && \
		@INSTALL_mplayer@
#	@DISTCLEANUP_mplayer@
	[ "x$*" = "x" ] && touch $@ || true

#
# MENCODER
#
#$(DEPDIR)/mencoder.do_prepare: bootstrap @DEPENDS_mencoder@
#	@PREPARE_mencoder@
#	touch $@

$(DEPDIR)/mencoder.do_compile: $(DEPDIR)/mplayer.do_prepare
	cd @DIR_mencoder@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-dvdnav \
			--disable-dvdread \
			--disable-dvdread-internal \
			--disable-libdvdcss-internal \
			--disable-libvorbis \
			--disable-mp3lib \
			--disable-liba52 \
			--disable-mad \
			--disable-vcd \
			--disable-ftp \
			--disable-pvr \
			--disable-tv-v4l2 \
			--disable-tv-v4l1 \
			--disable-tv \
			--disable-network \
			--disable-real \
			--disable-xanim \
			--disable-faad-internal \
			--disable-tremor-internal \
			--disable-pnm \
			--disable-ossaudio \
			--disable-tga \
			--disable-v4l2 \
			--disable-fbdev \
			--disable-dvb \
			--disable-mplayer && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/min-mencoder $(DEPDIR)/std-mencoder $(DEPDIR)/max-mencoder \
$(DEPDIR)/mencoder: \
$(DEPDIR)/%mencoder: $(DEPDIR)/mencoder.do_compile
	cd @DIR_mencoder@ && \
		@INSTALL_mencoder@
#	@DISTCLEANUP_mencoder@
	[ "x$*" = "x" ] && touch $@ || true

#
# UTIL-LINUX
#
if STM24
# for stm24, look in contrib-apps-specs.mk
else !STM24
DESCRIPTION_util_linux = "util-linux"
FILES_util_linux = \
/sbin/*

$(DEPDIR)/util-linux.do_prepare: bootstrap @DEPENDS_util_linux@
	@PREPARE_util_linux@
	cd @DIR_util_linux@ && \
		for p in `grep -v "^#" debian/patches/00list` ; do \
			patch -p1 < debian/patches/$$p.dpatch; \
		done; \
		patch -p1 < $(buildprefix)/Patches/util-linux-stm.diff
	touch $@

$(DEPDIR)/util-linux.do_compile: $(DEPDIR)/util-linux.do_prepare
	cd @DIR_util_linux@ && \
		sed -e 's/\ && .\/conftest//g' < configure > configure.new && \
		chmod +x configure.new && mv configure.new configure && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure && \
		sed 's/CURSESFLAGS=.*/CURSESFLAGS=-DNCH=1/' make_include > make_include.new && \
		mv make_include make_include.bak && \
		mv make_include.new make_include && \
		$(MAKE) ARCH=sh4 HAVE_SLANG=no HAVE_SHADOW=yes HAVE_PAM=no
	touch $@

$(DEPDIR)/min-util-linux $(DEPDIR)/std-util-linux $(DEPDIR)/max-util-linux \
$(DEPDIR)/util-linux: \
$(DEPDIR)/%util-linux: util-linux.do_compile
	$(start_build)
	cd @DIR_util_linux@ && \
		install -d $(PKDIR)/sbin && \
		install -m 755 fdisk/sfdisk $(PKDIR)/sbin/
	$(tocdk_build)
	$(toflash_build)
#		$(MAKE) ARCH=sh4 HAVE_SLANG=no HAVE_SHADOW=yes HAVE_PAM=no \
#		USE_TTY_GROUP=no INSTALLSUID='$(INSTALL) -m $(SUIDMODE)' \
#		DESTDIR=$(PKDIR) install && \
#		ln -s agetty $(PKDIR)/sbin/getty && \
#		ln -s agetty.8.gz $(PKDIR)/usr/man/man8/getty.8.gz && \
#		install -m 755 debian/hwclock.sh $(PKDIR)/etc/init.d/hwclock.sh && \
#		( cd po && make install DESTDIR=$(PKDIR) )
#		@INSTALL_util_linux@
#	@DISTCLEANUP_util_linux@
	[ "x$*" = "x" ] && touch $@ || true
endif !STM24

#
# jfsutils
#
DESCRIPTION_jfsutils = "jfsutils"
FILES_jfsutils = \
/sbin/*

$(DEPDIR)/jfsutils.do_prepare: bootstrap @DEPENDS_jfsutils@
	@PREPARE_jfsutils@
	touch $@

$(DEPDIR)/jfsutils.do_compile: $(DEPDIR)/jfsutils.do_prepare
	cd @DIR_jfsutils@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--host=gcc \
			--target=$(target) \
			--prefix= && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/min-jfsutils $(DEPDIR)/std-jfsutils $(DEPDIR)/max-jfsutils \
$(DEPDIR)/jfsutils: \
$(DEPDIR)/%jfsutils: $(DEPDIR)/jfsutils.do_compile
	$(start_build)
	cd @DIR_jfsutils@ && \
		@INSTALL_jfsutils@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_jfsutils@
	[ "x$*" = "x" ] && touch $@ || true

#
# opkg
#

DESCRIPTION_opkg = "lightweight package management system"
FILES_opkg = \
/usr/bin \
/usr/lib

$(DEPDIR)/opkg.do_prepare: bootstrap @DEPENDS_opkg@
	@PREPARE_opkg@
	touch $@

$(DEPDIR)/opkg.do_compile: $(DEPDIR)/opkg.do_prepare
	cd @DIR_opkg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-curl \
			--disable-gpg \
			--with-opkglibdir=/usr/lib && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-opkg $(DEPDIR)/std-opkg $(DEPDIR)/max-opkg \
$(DEPDIR)/opkg: \
$(DEPDIR)/%opkg: $(DEPDIR)/opkg.do_compile
	$(start_build)
	cd @DIR_opkg@ && \
		@INSTALL_opkg@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_opkg@
	[ "x$*" = "x" ] && touch $@ || true

#
# ntpclient
#

# PARENT_PK defined as per rule variable below is main postfix
# at first split_packages.py searches for variable PACKAGES_ + $(PARENT_PK)
# PACKAGES_ntpclient = ntpclient
# this is the default.
# PACKAGES_ntpclient = $(PARENT_PK)
# secondly for each package in the list it looks for control fields.
# the default control field is PARENT_PK one.

DESCRIPTION_ntpclient := time sync over ntp protocol
#this is default
#MAINTAINER_ntpclient := Ar-P team
#Source: are handled by smart-rules
#SRC_URI_ntpclient =
#PACKAGE_ARCH_ntpclient := sh4
#the Package: field in control file
#NAME_ntpclient := ntpclient
#mask for files to package
FILES_ntpclient := /sbin /etc
#version is handled by smart-rules
#PKGV_ntpclient =
PKGR_ntpclient = r0
# comment symbol '#' in define goes directly to split_packages.py. You do not need to escape it!
# moreover line breaks are also correctly exported to python, enjoy!
define postinst_ntpclient
#!/bin/sh
update-rc.d mgcamd_1.35 defaults 65
endef
define postrm_ntpclient
#!/bin/sh
update-rc.d mgcamd_1.35 remove
endef

$(DEPDIR)/ntpclient.do_prepare: @DEPENDS_ntpclient@
	@PREPARE_ntpclient@
	touch $@

$(DEPDIR)/ntpclient.do_compile: $(DEPDIR)/ntpclient.do_prepare
	cd @DIR_ntpclient@  && \
		export CC=sh4-linux-gcc CFLAGS="$(TARGET_CFLAGS)"; \
		$(MAKE) ntpclient; \
		$(MAKE) adjtimex
	touch $@

$(DEPDIR)/ntpclient: $(DEPDIR)/ntpclient.do_compile
	$(start_build)
	cd @DIR_ntpclient@  && \
		install -D -m 0755 ntpclient $(PKDIR)/sbin/ntpclient; \
		install -D -m 0755 adjtimex $(PKDIR)/sbin/adjtimex; \
		install -D -m 0755 rate.awk $(PKDIR)/sbin/ntpclient-drift-rate.awk
	install -D -m 0755 Patches/ntpclient-init.file $(PKDIR)/etc/init.d/ntpclient
	$(extra_build)
	touch $@

#
# udpxy
#

# You can use it as example of building and making package for new utility.
# First of all take a look at smart-rules file. Read the documentation at the beginning.
#
# At the first stage let's build one single package. For example udpxy. Be careful, each package name should be unique.
# First of all you should define some necessary info about your package.
# Such as 'Description:' field in control file

DESCRIPTION_udpxy := udp to http stream proxy

# Next set package release number and increase it each time you change something here in make scripts.
# Release number is part of the package version, updating it tells others that they can upgrade their system now.

PKGR_udpxy = r0

# Other variables are optional and have default values and another are taken from smart-rules (full list below)
# Usually each utility is split into three make-targets. Target name and package name 'udpxy' should be the same.
# Write
#  $(DEPDIR)/udpxy.do_prepare:
# But not
#  $(DEPDIR)/udpxy_proxy.do_prepare:
# *exceptions of this rule discussed later.

# Also target should contain only A-z characters and underscore "_".

# Firstly, downloading and patching. Use @DEPENDS_udpxy@ from smart rules as target-depends.
# In the body use @PREPARE_udpxy@ generated by smart-rules
# You can add your special commands too.

$(DEPDIR)/udpxy.do_prepare: @DEPENDS_udpxy@
	@PREPARE_udpxy@
	touch $@

# Secondly, the configure and compilation stage
# Each target should ends with 'touch $@'

$(DEPDIR)/udpxy.do_compile: $(DEPDIR)/udpxy.do_prepare
	cd $(DIR_udpxy) && \
		export CC=sh4-linux-gcc && \
		$(MAKE)
	touch $@

# Finally, install and packaging!
# How does it works:
#  start with line $(start_build) to prepare temporary directories and determine package name by the target name.
#  At first all files should go to temporary directory $(PKDIR) which is cdk/packagingtmpdir.
#  If you fill $(PKDIR) correctly then our scripts could proceed.
#  You could call one of the following:
#    $(tocdk_build) - copy all $(PKDIR) contents to tufsbox/cdkroot to use them later if something depends on them.
#    $(extra_build) - perform strip and cleanup, then make package ready to install on your box. You can find ipk in tufsbox/ipkbox
#    $(toflash_build) - At first do exactly that $(extra_build) does. After install package to pkgroot to include it in image.
#    $(e2extra_build) - same as $(extra_build) but copies ipk to tufsbox/ipkextras
#  Tip: $(tocdk_build) and $(toflash_build) could be used simultaneously.

$(DEPDIR)/udpxy: $(DEPDIR)/udpxy.do_compile
	$(start_build)
	cd $(DIR_udpxy)  && \
		export INSTALLROOT=$(PKDIR)/usr && \
		$(MAKE) install
	$(extra_build)
	touch $@

# Note: all above defined variables has suffix 'udpxy' same as make-target name '$(DEPDIR)/udpxy'
# If you want to change name of make-target for some reason add $(call parent_pk,udpxy) before $(start_build) line.
# Of course place your variables suffix instead of udpxy.

# Some words about git and svn.
# It is available to automatically determine version from git and svn
# If there is git/svn rule in smart-rules and the version equals git/svn then the version will be automatically evaluated during $(start_build)
# Note: it is assumed that there is only one repo for the utility.
# If you use your own git/svn fetch mechanism we provide you with $(get_git_version) or $(get_svn_version), but make sure that DIR_foo is git/svn repo.

# FILES variable
# FILES variable is the filter for your $(PKDIR), by default it equals "/" so all files from $(PKDIR) are built into the package. It is list of files and directories separated by space. Wildcards are supported.
# Wildcards used in the FILES variables are processed via the python function fnmatch. The following items are of note about this function:
#   /<dir>/*: This will match all files and directories in the dir - it will not match other directories.
#   /<dir>/a*: This will only match files, and not directories.
#   /dir: will include the directory dir in the package, which in turn will include all files in the directory and all subdirectories.

# Info about some additional variables
# PKGV_foo
#  Taken from smart rules version. Set if you don't use smart-rules
# SRC_URI_foo
#  Sources from which package is built, taken from smart-rules file://, http://, git://, svn:// rules.
# NAME_foo
#  If real package name is too long put it in this variable. By default it is like in varible names.
# Next variables has default values and influence CONTROL file fields only:
# MAINTAINER_foo := Ar-P team
# PACKAGE_ARCH_foo := sh4
# SECTION_foo := base
# PRIORITY_foo := optional
# LICENSE_foo := unknown
# HOMEPAGE_foo := unknown
# You set package dependencies in CONTROL file with:
# RDEPENDS_foo :=
# RREPLACES :=
# RCONFLICTS :=

# post/pre inst/rm Scripts
# For these sripts use make define as following:

define postinst_foo
#!/bin/sh
initdconfig --add foo
endef

# This is all about scripts
# Note: init.d script starting and stopping is handled by initdconfig

# Multi-Packaging
# When you whant to split files from one target to different packages you should set PACKAGES_parentfoo value.
# By default parentfoo is equals make target name. Place subpackages names to PACKAGES_parentfoo variable,
# parentfoo could be also in the list. Example:
## PACKAGES_megaprog = megaprog_extra megaprog
# Then set FILES for each subpackage
## FILES_megaprog = /bin/prog /lib/*.so*
## FILES_megaprog_extra = /lib/megaprog-addon.so
# NOTE: files are moving to pacakges in same order they are listed in PACKAGES variable.

# Optional install to flash
# When you call $(tocdk_build)/$(toflash_build) all packages are installed to image.
# If you want to select some non-installing packages from the same target (multi-packaging case)
# just list them in EXTRA_parentfoo variable
# DIST_parentfoo variable works vice-versa

# sysstat
#
$(DEPDIR)/sysstat: bootstrap @DEPENDS_sysstat@
	@PREPARE_sysstat@
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sysstat@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--disable-documentation && \
		$(MAKE) && \
		@INSTALL_sysstat@
	@DISTCLEANUP_sysstat@
	@touch $@

#
# hotplug-e2
#
DESCRIPTION_hotplug_e2 = "hotplug_e2"
FILES_hotplug_e2 = \
/sbin/bdpoll \
/usr/bin/hotplug_e2_helper

$(DEPDIR)/hotplug_e2.do_prepare: bootstrap @DEPENDS_hotplug_e2@
	@PREPARE_hotplug_e2@
	touch $@

$(DEPDIR)/hotplug_e2.do_compile: $(DEPDIR)/hotplug_e2.do_prepare
	cd @DIR_hotplug_e2@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-hotplug_e2 $(DEPDIR)/std-hotplug_e2 $(DEPDIR)/max-hotplug_e2 \
$(DEPDIR)/hotplug_e2: \
$(DEPDIR)/%hotplug_e2: $(DEPDIR)/hotplug_e2.do_compile
	$(start_build)
	cd @DIR_hotplug_e2@ && \
		@INSTALL_hotplug_e2@
	$(tocdk_build)
	mkdir $(PKDIR)/sbin
	cp -f $(PKDIR)/usr/bin/* $(PKDIR)/sbin
	$(toflash_build)
#	@DISTCLEANUP_hotplug_e2@
	[ "x$*" = "x" ] && touch $@ || true

#
# autofs
#
DESCRIPTION_autofs = "autofs"
FILES_autofs = \
/usr/*

$(DEPDIR)/autofs.do_prepare: bootstrap @DEPENDS_autofs@
	@PREPARE_autofs@
	touch $@

$(DEPDIR)/autofs.do_compile: $(DEPDIR)/autofs.do_prepare
	cd @DIR_autofs@ && \
		cp aclocal.m4 acinclude.m4 && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all CC=$(target)-gcc STRIP=$(target)-strip
	touch $@

$(DEPDIR)/min-autofs $(DEPDIR)/std-autofs $(DEPDIR)/max-autofs \
$(DEPDIR)/autofs: \
$(DEPDIR)/%autofs: $(DEPDIR)/autofs.do_compile
	$(start_build)
	cd @DIR_autofs@ && \
		@INSTALL_autofs@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_autofs@
	[ "x$*" = "x" ] && touch $@ || true

#
# imagemagick
#
DESCRIPTION_imagemagick = "imagemagick"
FILES_imagemagick = \
/usr/*
$(DEPDIR)/imagemagick.do_prepare: bootstrap @DEPENDS_imagemagick@
	@PREPARE_imagemagick@
	touch $@

$(DEPDIR)/imagemagick.do_compile: $(DEPDIR)/imagemagick.do_prepare
	cd @DIR_imagemagick@ && \
	$(BUILDENV) \
	CFLAGS="-O1" \
	PKG_CONFIG=$(hostprefix)/bin/pkg-config \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--without-dps \
		--without-fpx \
		--without-gslib \
		--without-jbig \
		--without-jp2 \
		--without-lcms \
		--without-tiff \
		--without-xml \
		--without-perl \
		--disable-openmp \
		--disable-opencl \
		--without-zlib \
		--enable-shared \
		--enable-static \
		--without-x && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-imagemagick $(DEPDIR)/std-imagemagick $(DEPDIR)/max-imagemagick \
$(DEPDIR)/imagemagick: \
$(DEPDIR)/%imagemagick: $(DEPDIR)/imagemagick.do_compile
	$(start_build)
	cd @DIR_imagemagick@ && \
		@INSTALL_imagemagick@
	$(tocdk_build)
	$(toflash_build)
#	@DISTCLEANUP_imagemagick@
	[ "x$*" = "x" ] && touch $@ || true

#
# grab
#

DESCRIPTION_grab = make enigma2 screenshots
RDEPENDS_grab = libpng jpeg

$(DEPDIR)/grab.do_prepare: bootstrap $(RDEPENDS_grab) @DEPENDS_grab@
	@PREPARE_grab@
	touch $@

$(DEPDIR)/grab.do_compile: grab.do_prepare
	cd @DIR_grab@ && \
		$(BUILDENV) && \
		autoreconf -i && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr
	touch $@

$(DEPDIR)/grab: grab.do_compile
	$(start_build)
	cd @DIR_grab@ && \
		@INSTALL_grab@
	$(toflash_build)
	touch $@
