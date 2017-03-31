#http://www.ntop.org/
include $(TOPDIR)/rules.mk

# Kernel module example
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
PKG_NAME:=xt_ndpi
PKG_RELEASE:=1.8
include $(INCLUDE_DIR)/package.mk

define KernelPackage/xt_ndpi
  SECTION:=oem
  CATEGORY:=OEM
  TITLE:=xt_ndpi
  DEPENDS:=+iptables +iptables-mod-conntrack-extra
  AUTOLOAD:=$(call AutoLoad,90,xt_ndpi)
  FILES:=$(PKG_BUILD_DIR)/xt_ndpi.$(LINUX_KMOD_SUFFIX)
endef


define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef

#define Package/ndpi-ipt/configure
#	$(call Build/Configure/Default)
#endef

DPI_FLAGS:= -I$(PKG_BUILD_DIR)/ndpi/include -I$(PKG_BUILD_DIR)/ndpi/lib -DOPENDPI_NETFILTER_MODULE -DNDPI_IPTABLES_EXT

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	ARCH="$(LINUX_KARCH)" \
	SUBDIRS="$(PKG_BUILD_DIR)/" \
	EXTRA_CFLAGS="-g $(BUILDFLAGS) $(DPI_FLAGS)"  \
	modules
endef

$(eval $(call KernelPackage,xt_ndpi))
