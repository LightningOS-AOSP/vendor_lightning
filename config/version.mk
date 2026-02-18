PRODUCT_VERSION_MAJOR = 16
PRODUCT_VERSION_MINOR = 0

# Increase Lightning Version with each major release.
LIGHTNING_VERSION_DISPLAY := 
LIGHTNING_FLAVOR := 
LIGHTNING_VERSION_BASE := 
LIGHTNING_CODENAME := 
LIGHTNING_BUILD_TYPE ?= Unofficial

LIGHTNING_BUILD_DATE := $(shell date -u +%Y%m%d)

CURRENT_DEVICE := $(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
OFFICIAL_MAINTAINERS := $(shell cat lightning-maintainers/lightning.maintainers)
OFFICIAL_DEVICES := $(shell cat lightning-maintainers/lightning.devices)

ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
  # Device not listed as official
  LIGHTNING_BUILD_TYPE := UNOFFICIAL
else
  # Check if builder is an official maintainer
  ifeq ($(findstring $(LIGHTNINGOS_MAINTAINER), $(OFFICIAL_MAINTAINERS)),)
    # Builder not an official maintainer, warn and set unofficial
    $(warning **********************************************************************)
    $(warning *   There is already an official maintainer for $(LINEAGE_BUILD)    *)
    $(warning *              Setting build type to UNOFFICIAL                      *)
    $(warning **********************************************************************)
    LIGHTNING_BUILD_TYPE := UNOFFICIAL
  else
    # Official maintainer building official device
    LIGHTNING_BUILD_TYPE := OFFICIAL
  endif
endif

# Enforce official build for official maintainers on official devices
ifeq ($(LIGHTNING_BUILD_TYPE), OFFICIAL)
  ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
    # Shouldn't reach here, error for unexpected situation
    $(error **********************************************************)
    $(error *     A violation has been detected, aborting build      *)
    $(error **********************************************************)
  endif
endif


# Lightning Packages
#ifeq ($(WITH_GMS),true)
#  ifeq ($(TARGET_USES_MINI_GAPPS), true)
#    LIGHTNING_PACKAGE_TYPE ?= MINI
#  else ifeq ($(TARGET_USES_PICO_GAPPS), true)
#    LIGHTNING_PACKAGE_TYPE ?= PICO
#  else
#    LIGHTNING_PACKAGE_TYPE ?= GAPPS
#  endif
#else
#  LIGHTNING_PACKAGE_TYPE ?= VANILLA
#endif

# Internal version
LINEAGE_VERSION := LightningOS-$(LIGHTNING_VERSION_BASE)-$(LIGHTNING_CODENAME)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(LIGHTNING_PACKAGE_TYPE)-$(shell date +%Y%m%d-%H%M)-$(LINEAGE_BUILD)-$(LIGHTNING_BUILD_TYPE)

# Display version
LINEAGE_DISPLAY_VERSION := LightningOS-$(LIGHTNING_VERSION_BASE)-$(LIGHTNING_CODENAME)-$(LIGHTNING_PACKAGE_TYPE)-$(LINEAGE_BUILD)-$(LIGHTNING_BUILD_TYPE)-$(shell date +%Y%m%d-%H%M)

# LineageOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.lightning.version=$(LINEAGE_VERSION) \
    ro.lightning.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.lightning.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(LIGHTNING_VERSION) \
    ro.lightning.packagetype=$(LIGHTNING_PACKAGE_TYPE) \
    ro.lightning.version_display=$(LIGHTNING_VERSION_DISPLAY) \
    ro.lightning.version.base=$(LIGHTNING_VERSION_BASE) \
    ro.lightningos.maintainer=$(LIGHTNINGOS_MAINTAINER) \
    ro.lightningos.flavor=$(LIGHTNING_FLAVOR) \
    ro.lightning.codename=$(LIGHTNING_CODENAME) \
    ro.lightning.buildtype=$(LIGHTNING_BUILD_TYPE)
