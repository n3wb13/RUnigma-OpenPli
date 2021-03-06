## Makefile for Tuxbox

#Some staff for building and splitting ipk packages with python
include packaging.mk

# Set up the build environment
include make/buildenv.mk

# Include Archive targets (SPECS derived)
include make/archive-specs.mk

# Include host apps targets
include make/hostapps.mk

# Include bootstrap targets (SPECS derived)
include make/bootstrap.mk

# Include u-boot targets
if ENABLE_TF7700
include make/tf_u-boot.mk
else
include make/u-boot.mk
endif

# Include adapted etc files and etc read-write files
include make/root-etc.mk

# Include bare-os targets (mainly SPECS derived)
include make/bare-os.mk

# Include linux kernel targets
include make/linux-kernel.mk

# Include busybox targets
include make/busybox.mk

# Include contrib lib targets
include make/contrib-libs.mk

# Include contrib apps (SPECS derived)
include make/contrib-apps-specs.mk

# Include contrib apps
include make/contrib-apps.mk

# Include net apps
include make/net-apps.mk

# Include divers tools targets
#include make/diverse-tools.mk

# More misc libs, mostly nonessential
include make/misc_libs.mk

# Misc tools, not essential
include make/misc_tools.mk

# Plugins
include make/plugins.mk

# Include enigma gui targets
#include make/enigma.mk

# Include enigma2 gui targets
#include make/enigma2.mk

# Include enigma2 plugins targets
include make/enigma2-plugins.mk

# Include enigma2-nightly gui targets
include make/enigma2-nightly.mk

# ExternePlugins
include make/externe-plugins.mk

# ExterneSkins
include make/externe-skins.mk

# Include enigma2-pli-nightly gui targets
include make/enigma2-pli-nightly.mk

# Include xbmc-nightly gui targets
include make/xbmc-nightly.mk

# Include neutrino gui targets
include make/neutrino.mk
include make/neutrino_hd2.mk

# Include vdr gui targets
include make/vdr.mk

# Include enigma1-hd gui targets
#include make/enigma1-hd.mk

# Essential, and some less essential, libraries
#include make/tuxbox_libs.mk

# A small, but absolutely essential library
include make/libtuxbox.mk

# Include yaud targets
include make/yaud.mk

# Include misc targets (SPECS derived)
# (splashutils)
include make/misc-specs.mk

# A number of cleaning targets
include make/cleantargets.mk

# Create the TAGS file
include make/tags.mk

# Target for building source distributions (hardly used these days of CVS :-)
include make/disttargets.mk

#Trick
include make/smart_release.mk

include make/smart_release_xbmc.mk

include make/release_neutrino.mk

include make/release_neutrino_nightly.mk

include make/release_vdr.mk

include make/release_enigma1_hd.mk

# New static folder
include make/release_neutrino_static.mk

# Give the user rope to hang himself :-).  (Note: read from the
# generated Makefile during make run, automake or configure does not
# see it.)
-include ./Makefile.local

# installer image for TF7700
include make/tfinstaller.mk

download-for-smart: @DOWNLOAD_FOR_SMART@
@SMART_DOWNLOAD_RULES@
# this makes sure we do not build top-level dependencies in parallel
# (which would not be too helpful anyway, running many configure and
# downloads in parallel...), but the sub-targets are still built in
# parallel, which is useful on multi-processor / multi-core machines
.NOTPARALLEL:
