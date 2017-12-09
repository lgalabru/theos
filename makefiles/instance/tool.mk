ifeq ($(_THEOS_RULES_LOADED),)
include $(THEOS_MAKE_PATH)/rules.mk
endif

.PHONY: internal-tool-all_ internal-tool-stage_ internal-tool-compile

ifeq ($(_THEOS_MAKE_PARALLEL_BUILDING), no)
internal-tool-all_:: $(_OBJ_DIR_STAMPS) $(THEOS_OBJ_DIR)/$(THEOS_CURRENT_INSTANCE)$(TARGET_EXE_EXT)
else
internal-tool-all_:: $(_OBJ_DIR_STAMPS)
	$(ECHO_MAKE)$(MAKE) -f $(_THEOS_PROJECT_MAKEFILE_NAME) --no-print-directory --no-keep-going \
		internal-tool-compile \
		_THEOS_CURRENT_TYPE=$(_THEOS_CURRENT_TYPE) THEOS_CURRENT_INSTANCE=$(THEOS_CURRENT_INSTANCE) _THEOS_CURRENT_OPERATION=compile \
		THEOS_BUILD_DIR="$(THEOS_BUILD_DIR)" _THEOS_MAKE_PARALLEL=yes

internal-tool-compile: $(THEOS_OBJ_DIR)/$(THEOS_CURRENT_INSTANCE)$(TARGET_EXE_EXT)
endif

$(eval $(call _THEOS_TEMPLATE_DEFAULT_LINKING_RULE,$(THEOS_CURRENT_INSTANCE)$(TARGET_EXE_EXT)))

LOCAL_INSTALL_PATH = $(strip $($(THEOS_CURRENT_INSTANCE)_INSTALL_PATH))
ifeq ($(LOCAL_INSTALL_PATH),)
	LOCAL_INSTALL_PATH = $($(THEOS_CURRENT_INSTANCE)_PACKAGE_TARGET_DIR)
	ifeq ($(LOCAL_INSTALL_PATH),)
		LOCAL_INSTALL_PATH = /usr/bin
	endif
endif

ifneq ($($(THEOS_CURRENT_INSTANCE)_INSTALL),0)
internal-tool-stage_::
	$(ECHO_NOTHING)mkdir -p "$(THEOS_STAGING_DIR)$(LOCAL_INSTALL_PATH)"$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/$(THEOS_CURRENT_INSTANCE)$(TARGET_EXE_EXT) "$(THEOS_STAGING_DIR)$(LOCAL_INSTALL_PATH)"$(ECHO_END)
endif

$(eval $(call __mod,instance/tool.mk))
