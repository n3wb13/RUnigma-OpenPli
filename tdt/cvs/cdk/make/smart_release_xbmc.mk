# auxiliary targets for model-specific builds
release_xbmc_common_utils:
# opkg config
	mkdir -p $(prefix)/release/etc/opkg
	mkdir -p $(prefix)/release/usr/lib/locale
	cp -f $(buildprefix)/root/release/official-feed.conf $(prefix)/release/etc/opkg/
	cp -f $(buildprefix)/root/release/opkg.conf $(prefix)/release/etc/
	$(call initdconfig,$(shell ls $(prefix)/release/etc/init.d))

# Copy video_7100
	$(if $(ADB_BOX)$(VIP2_V1)$(UFS910)$(HOMECAST5101),cp -f $(archivedir)/boot/video_7100.elf $(prefix)/release/boot/video.elf)
# Copy audio_7100
	$(if $(ADB_BOX)$(VIP2_V1)$(UFS910)$(HOMECAST5101),cp -f $(archivedir)/boot/audio_7100.elf $(prefix)/release/boot/audio.elf)
# Copy video_7105
	$(if $(ATEVIO7500)$(SPARK7162),cp -f $(archivedir)/boot/video_7105.elf $(prefix)/release/boot/video.elf)
# Copy audio_7105
	$(if $(ATEVIO7500)$(SPARK7162),cp -f $(archivedir)/boot/audio_7105.elf $(prefix)/release/boot/audio.elf)
# Copy video_7109
	$(if $(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(FORTIS_HDBOX)$(OCTAGON1008)$(HL101)$(TF7700)$(VIP1_V2)$(VIP2_V1)$(UFS922)$(IPBOX9900)$(IPBOX99)$(IPBOX55),cp -f $(archivedir)/boot/video_7109.elf $(prefix)/release/boot/video.elf)
# Copy audio_7109
	$(if $(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(FORTIS_HDBOX)$(OCTAGON1008)$(HL101)$(TF7700)$(VIP1_V2)$(VIP2_V1)$(UFS922)$(IPBOX9900)$(IPBOX99)$(IPBOX55),cp -f $(archivedir)/boot/audio_7109.elf $(prefix)/release/boot/audio.elf)
# Copy video_7111
	$(if $(SPARK)$(UFS912)$(HS7810A)$(HS7110)$(WHITEBOX),cp -f $(archivedir)/boot/video_7111.elf $(prefix)/release/boot/video.elf)
# Copy audio_7111
	$(if $(SPARK)$(UFS912)$(HS7810A)$(HS7110)$(WHITEBOX),cp -f $(archivedir)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf )
	
release_xbmc_base:
	rm -rf $(prefix)/release || true
	$(INSTALL_DIR) $(prefix)/release && \
	cp -rp $(prefix)/pkgroot/* $(prefix)/release
# filesystem
	$(INSTALL_DIR) $(prefix)/release/bin && \
	$(INSTALL_DIR) $(prefix)/release/sbin && \
	$(INSTALL_DIR) $(prefix)/release/boot && \
	$(INSTALL_DIR) $(prefix)/release/dev && \
	$(INSTALL_DIR) $(prefix)/release/dev.static && \
	$(INSTALL_DIR) $(prefix)/release/etc && \
	$(INSTALL_DIR) $(prefix)/release/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-post-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-pre-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release/etc/enigma2 && \
	$(INSTALL_DIR) $(prefix)/release/media && \
	$(INSTALL_DIR) $(prefix)/release/media/dvd && \
	$(INSTALL_DIR) $(prefix)/release/media/net && \
	$(INSTALL_DIR) $(prefix)/release/mnt && \
	$(INSTALL_DIR) $(prefix)/release/mnt/usb && \
	$(INSTALL_DIR) $(prefix)/release/mnt/hdd && \
	$(INSTALL_DIR) $(prefix)/release/mnt/nfs && \
	$(INSTALL_DIR) $(prefix)/release/root && \
	$(INSTALL_DIR) $(prefix)/release/proc && \
	$(INSTALL_DIR) $(prefix)/release/sys && \
	$(INSTALL_DIR) $(prefix)/release/tmp && \
	$(INSTALL_DIR) $(prefix)/release/usr && \
	$(INSTALL_DIR) $(prefix)/release/usr/bin && \
	$(INSTALL_DIR) $(prefix)/release/media/hdd && \
	$(INSTALL_DIR) $(prefix)/release/media/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release/media/hdd/picture && \
	ln -sf /media/hdd $(prefix)/release/hdd && \
	$(INSTALL_DIR) $(prefix)/release/lib && \
	$(INSTALL_DIR) $(prefix)/release/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release/lib/firmware && \
	$(INSTALL_DIR) $(prefix)/release/ram && \
	$(INSTALL_DIR) $(prefix)/release/var && \
	$(INSTALL_DIR) $(prefix)/release/var/etc && \
	mkdir -p $(prefix)/release/var/run/lirc && \
	$(INSTALL_DIR) $(prefix)/release/usr/lib/opkg && \
	ln -sf /usr/bin/opkg-cl  $(prefix)/release/usr/bin/ipkg-cl && \
	ln -sf /usr/bin/opkg-cl  $(prefix)/release/usr/bin/opkg && \
	ln -sf /usr/bin/opkg-cl  $(prefix)/release/usr/bin/ipkg
# rc.d directories
	mkdir -p $(prefix)/release/etc/rc.d/rc{0,1,2,3,4,5,6,S}.d
	ln -sf ../init.d $(prefix)/release/etc/rc.d
# zoneinfo
	$(INSTALL_DIR) $(prefix)/release/usr/share/zoneinfo && \
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release/usr/share/zoneinfo/
# udhcpc
	$(INSTALL_DIR) $(prefix)/release/usr/share/udhcpc && \
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release/usr/share/udhcpc/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/etc/timezone.xml $(prefix)/release/etc/ && \
	cp -a $(buildprefix)/root/etc/Wireless $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/firmware/*.bin $(prefix)/release/lib/firmware/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release/etc/network/ && \
	ln -sf /etc/timezone.xml $(prefix)/release/etc/tuxbox/timezone.xml && \
	ln -sf /usr/local/share/keymaps $(prefix)/release/usr/share/keymaps
	if [ -e $(targetprefix)/usr/share/alsa ]; then \
	mkdir -p $(prefix)/release/usr/share/alsa/; \
	mkdir -p $(prefix)/release/usr/share/alsa/cards/; \
	mkdir -p $(prefix)/release/usr/share/alsa/pcm/; \
	cp $(targetprefix)/etc/tuxbox/satellites.xml $(prefix)/release/etc/tuxbox/ && \
	cp $(targetprefix)/etc/tuxbox/cables.xml $(prefix)/release/etc/tuxbox/ && \
	cp $(targetprefix)/etc/tuxbox/terrestrial.xml $(prefix)/release/etc/tuxbox/ && \
	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release/boot/ && \
	cp $(targetprefix)/usr/share/alsa/alsa.conf          $(prefix)/release/usr/share/alsa/alsa.conf; \
	cp $(targetprefix)/usr/share/alsa/cards/aliases.conf $(prefix)/release/usr/share/alsa/cards/; \
	cp $(targetprefix)/usr/share/alsa/pcm/default.conf   $(prefix)/release/usr/share/alsa/pcm/; \
	cp $(targetprefix)/usr/share/alsa/pcm/dmix.conf      $(prefix)/release/usr/share/alsa/pcm/; fi
# AUTOFS
	if [ -d $(prefix)/release/usr/lib/autofs ]; then \
		cp -f $(buildprefix)/root/release/auto.hotplug $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/auto.network $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/autofs $(prefix)/release/etc/init.d/; \
	fi

# Copy lircd.conf
	cp -f $(buildprefix)/root/etc/lircd$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_vip2)$(if $(VIP2_V1),_vip2)$(if $(UFS912),_$(UFS912))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(HOMECAST5101),_$(HOMECAST5101))$(if $(IPBOX9900)$(IPBOX99)$(IPBOX55),_ipbox)$(if $(ADB_BOX),_$(ADB_BOX)).conf $(prefix)/release/etc/lircd.conf

	touch $(prefix)/release/var/etc/.firstboot && \
	cp -f $(buildprefix)/root/release/mme_check $(prefix)/release/etc/init.d/ && \
	cp -f $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release/boot/ && \
	cp -f $(buildprefix)/root/bin/autologin $(prefix)/release/bin/ && \
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release/bin/ && \
	cp -f $(buildprefix)/root/etc/vdstandby.cfg $(prefix)/release/etc/ && \
	cp -f $(buildprefix)/root/etc/init.d/avahi-daemon $(prefix)/release/etc/init.d/ && \
	chmod 777 $(prefix)/release/etc/init.d/avahi-daemon && \
	cp -f $(buildprefix)/root/etc/network/interfaces $(prefix)/release/etc/network/ && \
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release/sbin/ && \
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release/sbin/ && \
	cp -f $(buildprefix)/root/etc/image-version $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/fstab $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/hostname $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/inetd.conf $(prefix)/release/etc/ && \
	ln -s /usr/share/zoneinfo/Europe/Berlin $(prefix)/release/etc/localtime && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/profile $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release/etc/ && \
	cp -dp $(buildprefix)/root/etc/resolv.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release/etc/ && \
	ln -sf /usr/share/xbmc/language/German $(prefix)/release/usr/share/xbmc/language/English
	$(INSTALL_DIR) $(prefix)/release/etc/tuxbox && \
	$(INSTALL_FILE) root/etc/tuxbox/satellites.xml $(prefix)/release/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/tuxtxt2.conf $(prefix)/release/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/cables.xml $(prefix)/release/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/terrestrial.xml $(prefix)/release/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/timezone.xml $(prefix)/release/etc/ && \
	echo "576i50" > $(prefix)/release/etc/videomode

release_xbmc_cube_common:
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release/etc/init.d/reboot && \
	chmod 777 $(prefix)/release/etc/init.d/reboot && \
	cp $(buildprefix)/root/bin/eeprom $(prefix)/release/bin

release_xbmc_cuberevo_9500hd: release_cube_common
	echo "cuberevo-9500hd" > $(prefix)/release/etc/hostname

release_xbmc_cuberevo_2000hd: release_cube_common
	echo "cuberevo-2000hd" > $(prefix)/release/etc/hostname

release_xbmc_cuberevo_250hd: release_cube_common
	echo "cuberevo-250hd" > $(prefix)/release/etc/hostname

release_xbmc_cuberevo_mini_fta: release_cube_common
	echo "cuberevo-mini-fta" > $(prefix)/release/etc/hostname

release_xbmc_cuberevo_mini2: release_cube_common
	echo "cuberevo-mini2" > $(prefix)/release/etc/hostname

release_xbmc_cuberevo_mini: release_cube_common
	echo "cuberevo-mini" > $(prefix)/release/etc/hostname

release_xbmc_cuberevo: release_cube_common
	echo "cuberevo" > $(prefix)/release/etc/hostname
	
release_xbmc_ufs922:
	echo "ufs922" > $(prefix)/release/etc/hostname

release_xbmc_ufs912:
	echo "ufs912" > $(prefix)/release/etc/hostname && \
	cp $(buildprefix)/root/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
	
release_xbmc_spark:
	echo "spark" > $(prefix)/release/etc/hostname && \
	echo "src/gz AR-P http://alien.sat-universum.de" | cat - $(prefix)/release/etc/opkg/official-feed.conf > $(prefix)/release/etc/opkg/official-feed && \
	mv $(prefix)/release/etc/opkg/official-feed $(prefix)/release/etc/opkg/official-feed.conf && \
	cp $(buildprefix)/root/etc/lircd_spark.conf.09_00_0B $(prefix)/release/etc/lircd.conf.09_00_0B && \
	cp $(buildprefix)/root/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw && \
	$(if $(P0123),cp -dp $(archivedir)/ptinp/pti_123.ko $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko) \
	$(if $(P0207),cp -dp $(archivedir)/ptinp/pti_207.ko $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko) \
	$(if $(P0209),cp -dp $(archivedir)/ptinp/pti_209.ko $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko) \
	$(if $(P0210),cp -dp $(archivedir)/ptinp/pti_210.ko $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko) \
	$(if $(P0211),cp -dp $(archivedir)/ptinp/pti_211.ko $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko)

release_xbmc_spark7162:
	echo "spark7162" > $(prefix)/release/etc/hostname && \
	echo "src/gz AR-P http://alien2.sat-universum.de" | cat - $(prefix)/release/etc/opkg/official-feed.conf > $(prefix)/release/etc/opkg/official-feed && \
	mv -f $(prefix)/release/etc/opkg/official-feed $(prefix)/release/etc/opkg/official-feed.conf
	cp $(buildprefix)/root/firmware/component_7105_pdk7105.fw $(prefix)/release/lib/firmware/component.fw
	$(if $(P0207),cp -dp $(archivedir)/ptinp/pti_207s2.ko $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko)
	rm -f $(prefix)/release/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7106.ko

release_xbmc_fortis_hdbox:
	echo "fortis" > $(prefix)/release/etc/hostname
	
release_xbmc_atevio7500:
	echo "atevio7500" > $(prefix)/release/etc/hostname && \
	cp $(buildprefix)/root/firmware/component_7105_pdk7105.fw $(prefix)/release/lib/firmware/component.fw

release_xbmc_octagon1008:
	echo "octagon1008" > $(prefix)/release/etc/hostname && \
	cp $(buildprefix)/root/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/ && \
	cp $(buildprefix)/root/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/

release_xbmc_hs7810a:
	echo "hs7810a" > $(prefix)/release/etc/hostname && \
	cp $(buildprefix)/root/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw

release_xbmc_hs7110:
	echo "hs7110" > $(prefix)/release/etc/hostname && \
	cp $(buildprefix)/root/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw

release_xbmc_whitebox:
	echo "whitebox" > $(prefix)/release/etc/hostname && \
	cp $(buildprefix)/root/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw

release_xbmc_ufs910:
	echo "ufs910" > $(prefix)/release/etc/hostname && \
	cp $(buildprefix)/root/firmware/dvb-fe-cx21143.fw $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw

release_xbmc_hl101:
	echo "hl101" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/fstab_hl101 $(prefix)/release/etc/fstab
	cp $(buildprefix)/root/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/ && \
	cp $(buildprefix)/root/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/

release_xbmc_adb_box:
	echo "Adb_Box" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/fstab_adb_box $(prefix)/release/etc/fstab
	cp $(buildprefix)/root/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/ && \
	cp $(buildprefix)/root/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/

release_xbmc_vip1_v2: release_xbmc_common_utils
	echo "Edision-v2" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/vfd_vip2_stm23_0123.ko $(prefix)/release/lib/modules/vfd.ko && \
	cp -f $(buildprefix)/root/release/fstab_vip2 $(prefix)/release/etc/fstab

release_xbmc_vip2_v1: release_vip1_v2
	echo "Edision-v1" > $(prefix)/release/etc/hostname

release_xbmc_hs5101:
	echo "hs5101" > $(prefix)/release/etc/hostname

release_xbmc_tf7700: release_xbmc_common_utils
	echo "tf7700" > $(prefix)/release/etc/hostname
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release/etc/fstab

release_xbmc_ipbox9900: release_xbmc_common_utils
	echo "ipbox9900" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab && \
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release/usr/bin/tvmode && \
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd && \
	rm -f $(prefix)/release/lib/firmware/* && \
	rm -f $(prefix)/release/lib/modules/boxtype.ko && \
	rm -f $(prefix)/release/lib/modules/bpamem.ko && \
	rm -f $(prefix)/release/lib/modules/lzo*.ko && \
	rm -f $(prefix)/release/lib/modules/ramzswap.ko && \
	rm -f $(prefix)/release/lib/modules/simu_button.ko && \
	rm -f $(prefix)/release/lib/modules/stmvbi.ko && \
	rm -f $(prefix)/release/lib/modules/stmvout.ko && \
	rm -f $(prefix)/release/bin/gotosleep && \
	rm -f $(prefix)/release/etc/network/interfaces && \
	echo "config.usage.hdd_standby=0" >> $(prefix)/release/etc/enigma2/settings
	
release_xbmc_ipbox99: release_xbmc_common_utils
	echo "ipbox99" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab && \
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release/usr/bin/tvmode && \
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd && \
	rm -f $(prefix)/release/lib/firmware/* && \
	rm -f $(prefix)/release/lib/modules/boxtype.ko && \
	rm -f $(prefix)/release/lib/modules/bpamem.ko && \
	rm -f $(prefix)/release/lib/modules/lzo*.ko && \
	rm -f $(prefix)/release/lib/modules/ramzswap.ko && \
	rm -f $(prefix)/release/lib/modules/simu_button.ko && \
	rm -f $(prefix)/release/lib/modules/stmvbi.ko && \
	rm -f $(prefix)/release/lib/modules/stmvout.ko && \
	rm -f $(prefix)/release/bin/gotosleep && \
	rm -f $(prefix)/release/etc/network/interfaces && \
	echo "config.usage.hdd_standby=0" >> $(prefix)/release/etc/enigma2/settings

release_xbmc_ipbox55: release_xbmc_common_utils
	echo "ipbox55" > $(prefix)/release/etc/hostname && \
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab && \
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release/usr/bin/tvmode && \
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd && \
	rm -f $(prefix)/release/lib/firmware/* && \
	rm -f $(prefix)/release/lib/modules/boxtype.ko && \
	rm -f $(prefix)/release/lib/modules/bpamem.ko && \
	rm -f $(prefix)/release/lib/modules/lzo*.ko && \
	rm -f $(prefix)/release/lib/modules/ramzswap.ko && \
	rm -f $(prefix)/release/lib/modules/simu_button.ko && \
	rm -f $(prefix)/release/lib/modules/stmvbi.ko && \
	rm -f $(prefix)/release/lib/modules/stmvout.ko && \
	rm -f $(prefix)/release/bin/gotosleep && \
	rm -f $(prefix)/release/etc/network/interfaces && \
	echo "config.usage.hdd_standby=0" >> $(prefix)/release/etc/enigma2/settings


# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/min-release_xbmc $(DEPDIR)/std-release_xbmc $(DEPDIR)/max-release_xbmc $(DEPDIR)/release_xbmc: \
$(DEPDIR)/%release_xbmc:release_xbmc_base release_xbmc_common_utils release_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(WHITEBOX)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX)
# Post tweaks
	depmod -b $(prefix)/release $(KERNELVERSION)
	touch $@

release-xbmc_clean:
	rm -f $(DEPDIR)/release_xbmc
	rm -f $(DEPDIR)/release_xbmc_base
	rm -f $(DEPDIR)/release_xbmc_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(WHITEBOX)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX)
	rm -f $(DEPDIR)/release_xbmc_common_utils 
	rm -f $(DEPDIR)/release_xbmc_cube_common