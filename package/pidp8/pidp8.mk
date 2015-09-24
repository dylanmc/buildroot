################################################################################
#
# PiDP-8
#
################################################################################

PIDP8_VERSION = 20150923
# PIDP8_SITE = http://obsolescence.wix.com/obsolescence#!pidp-8/cbie
# PIDP8_SITE = <url goes here>
PIDP8_SITE = file:///home/pi/ 
PIDP8_SOURCE = pidp8_$(PIDP8_VERSION).tar.gz
PIDP8_DEPENDENCIES = ncurses screen 
PIDP8_LICENSE = modified X-Windows license
PIDP8_LICENSE_FILES = COPYING

define PIDP8_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/src
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/src/scanswitch
	echo $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/src/scanswitch
endef

define PIDP8_INSTALL_STAGING_CMDS
	echo nothing to do for staging
endef

define PIDP8_INSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/opt/pidp8
	mkdir -p $(TARGET_DIR)/opt/pidp8/bin
	mkdir $(TARGET_DIR)/opt/pidp8/etc
	mkdir -p $(TARGET_DIR)/media
	cp $(@D)/bin/pidp8 $(TARGET_DIR)/opt/pidp8/bin
	cp $(@D)/bin/scanswitch $(TARGET_DIR)/opt/pidp8/bin
	cp $(@D)/bin/automount $(TARGET_DIR)/opt/pidp8/bin
	cp $(@D)/bin/unmount $(TARGET_DIR)/opt/pidp8/bin
	cp $(@D)/etc/rc.pidp8 $(TARGET_DIR)/etc/init.d/S50pidp8
	cp $(@D)/etc/pdp.sh $(TARGET_DIR)/root/pdp.sh
	echo "./pdp.sh" > $(TARGET_DIR)/root/.profile
	cp $(@D)/etc/init-functions $(TARGET_DIR)/opt/pidp8/etc/
	cd $(@D) ; tar cf - bootscripts imagefiles | (cd $(TARGET_DIR)/opt/pidp8 ; tar xf -)
	# if ! grep -q 'ttyAMA0' $(TARGET_DIR)/etc/inittab ; then
	# fi
	echo "ttyAMA0::respawn:/sbin/getty -L  ttyAMA0 115200 vt100" >> $(TARGET_DIR)/etc/inittab

	echo "Welcome to PiDP/8 (fast boot courtesy buildroot)" > $(TARGET_DIR)/etc/issue
endef


$(eval $(generic-package))
