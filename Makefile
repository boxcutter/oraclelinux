# if Makefile.local exists, include it
ifneq ("$(wildcard Makefile.local)", "")
	include Makefile.local
endif

ORACLE65_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U5/x86_64/OracleLinux-R6-U5-Server-x86_64-dvd.iso
ORACLE64_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U4/x86_64/OracleLinux-R6-U4-Server-x86_64-dvd.iso
ORACLE63_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U3/x86_64/OracleLinux-R6-U3-Server-x86_64-dvd.iso
ORACLE62_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U2/x86_64/OracleLinux-R6-U2-Server-x86_64-dvd.iso
ORACLE61_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U1/x86_64/OracleLinux-R6-U1-Server-x86_64-dvd.iso
ORACLE510_X86_64 ?= iso/V40139-01.iso
ORACLE59_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/EL5/U9/x86_64/Enterprise-R5-U9-Server-x86_64-dvd.iso
ORACLE58_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/EL5/U8/x86_64/OracleLinux-R5-U8-Server-x86_64-dvd.iso
ORACLE57_X86_64 ?= http://mirrors.dotsrc.org/oracle-linux/EL5/U7/x86_64/Enterprise-R5-U7-Server-x86_64-dvd.iso
ORACLE65_I386 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U5/i386/OracleLinux-R6-U5-Server-i386-dvd.iso
ORACLE64_I386 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U4/i386/OracleLinux-R6-U4-Server-i386-dvd.iso
ORACLE63_I386 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U3/i386/OracleLinux-R6-U3-Server-i386-dvd.iso
ORACLE62_I386 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U2/i386/OracleLinux-R6-U2-Server-i386-dvd.iso"
ORACLE61_I386 ?= http://mirrors.dotsrc.org/oracle-linux/OL6/U1/x86/OracleLinux-R6-U1-Server-i386-dvd.iso
ORACLE510_I386 ?= iso/V40140-01.iso
ORACLE59_I386 ?= http://mirrors.dotsrc.org/oracle-linux/EL5/U9/i386/Enterprise-R5-U9-Server-i386-dvd.iso
ORACLE58_I386 ?= http://mirrors.dotsrc.org/oracle-linux/EL5/U8/i386/OracleLinux-R5-U8-Server-i386-dvd.iso
ORACLE57_I386 ?= http://mirrors.dotsrc.org/oracle-linux/EL5/U7/i386/Enterprise-R5-U7-Server-i386-dvd.iso


# Possible values for CM: (nocm | chef | chefdk | salt | puppet)
CM ?= nocm
# Possible values for CM_VERSION: (latest | x.y.z | x.y)
CM_VERSION ?=
ifndef CM_VERSION
	ifneq ($(CM),nocm)
		CM_VERSION = latest
	endif
endif
# Packer does not allow empty variables, so only pass variables that are defined
ifdef CM_VERSION
	PACKER_VARS := -var 'cm=$(CM)' -var 'cm_version=$(CM_VERSION)'
else
	PACKER_VARS := -var 'cm=$(CM)'
endif
ifeq ($(CM),nocm)
	BOX_SUFFIX := -$(CM).box
else
	BOX_SUFFIX := -$(CM)$(CM_VERSION).box
endif
BUILDER_TYPES := vmware virtualbox
TEMPLATE_FILENAMES := $(wildcard *.json)
BOX_FILENAMES := $(TEMPLATE_FILENAMES:.json=$(BOX_SUFFIX))
BOX_FILES := $(foreach builder, $(BUILDER_TYPES), $(foreach box_filename, $(BOX_FILENAMES), box/$(builder)/$(box_filename)))
TEST_BOX_FILES := $(foreach builder, $(BUILDER_TYPES), $(foreach box_filename, $(BOX_FILENAMES), test-box/$(builder)/$(box_filename)))
VMWARE_BOX_DIR := box/vmware
VIRTUALBOX_BOX_DIR := box/virtualbox
VMWARE_OUTPUT := output-vmware-iso
VIRTUALBOX_OUTPUT := output-virtualbox-iso
VMWARE_BUILDER := vmware-iso
VIRTUALBOX_BUILDER := virtualbox-iso
CURRENT_DIR = $(shell pwd)

.PHONY: all list clean

all: $(BOX_FILES)

test: $(TEST_BOX_FILES)

# Generic rule - not used currently
#$(VMWARE_BOX_DIR)/%$(BOX_SUFFIX): %.json
#	cd $(dir $<)
#	rm -rf output-vmware-iso
#	mkdir -p $(VMWARE_BOX_DIR)
#	packer build -only=vmware-iso $(PACKER_VARS) $<

$(VMWARE_BOX_DIR)/oracle65$(BOX_SUFFIX): oracle65.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE65_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle64$(BOX_SUFFIX): oracle64.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE64_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle63$(BOX_SUFFIX): oracle63.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE63_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle62$(BOX_SUFFIX): oracle62.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE62_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle61$(BOX_SUFFIX): oracle61.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE61_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle510$(BOX_SUFFIX): oracle510.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE510_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle59$(BOX_SUFFIX): oracle59.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE59_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle58$(BOX_SUFFIX): oracle58.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE58_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle57$(BOX_SUFFIX): oracle57.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE57_X86_64)" $<

$(VMWARE_BOX_DIR)/oracle65-i386$(BOX_SUFFIX): oracle65-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE65_I386)" $<

$(VMWARE_BOX_DIR)/oracle64-i386$(BOX_SUFFIX): oracle64-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE64_I386)" $<

$(VMWARE_BOX_DIR)/oracle63-i386$(BOX_SUFFIX): oracle63-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE63_I386)" $<

$(VMWARE_BOX_DIR)/oracle62-i386$(BOX_SUFFIX): oracle62-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE62_I386)" $<

$(VMWARE_BOX_DIR)/oracle61-i386$(BOX_SUFFIX): oracle61-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE61_I386)" $<

$(VMWARE_BOX_DIR)/oracle510-i386$(BOX_SUFFIX): oracle510-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE510_I386)" $<

$(VMWARE_BOX_DIR)/oracle59-i386$(BOX_SUFFIX): oracle59-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE59_I386)" $<

$(VMWARE_BOX_DIR)/oracle58-i386$(BOX_SUFFIX): oracle58-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE58_I386)" $<

$(VMWARE_BOX_DIR)/oracle57-i386$(BOX_SUFFIX): oracle57-i386.json
	rm -rf $(VMWARE_OUTPUT)
	mkdir -p $(VMWARE_BOX_DIR)
	packer build -only=$(VMWARE_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE57_I386)" $<

# Generic rule - not used currently
#$(VIRTUALBOX_BOX_DIR)/%$(BOX_SUFFIX): %.json
#	cd $(dir $<)
#	rm -rf output-virtualbox-iso
#	mkdir -p $(VIRTUALBOX_BOX_DIR)
#	packer build -only=virtualbox-iso $(PACKER_VARS) $<
	
$(VIRTUALBOX_BOX_DIR)/oracle65$(BOX_SUFFIX): oracle65.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE65_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle64$(BOX_SUFFIX): oracle64.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOS_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE64_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle63$(BOX_SUFFIX): oracle63.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOS_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE63_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle62$(BOX_SUFFIX): oracle62.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOS_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE62_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle61$(BOX_SUFFIX): oracle61.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOS_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE61_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle510$(BOX_SUFFIX): oracle510.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE510_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle59$(BOX_SUFFIX): oracle59.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE59_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle58$(BOX_SUFFIX): oracle58.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE58_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle57$(BOX_SUFFIX): oracle57.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE57_X86_64)" $<

$(VIRTUALBOX_BOX_DIR)/oracle65-i386$(BOX_SUFFIX): oracle65-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE65_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle64-i386$(BOX_SUFFIX): oracle64-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE64_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle63-i386$(BOX_SUFFIX): oracle63-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE63_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle62-i386$(BOX_SUFFIX): oracle62-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE62_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle61-i386$(BOX_SUFFIX): oracle61-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE61_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle510-i386$(BOX_SUFFIX): oracle510-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE510_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle59-i386$(BOX_SUFFIX): oracle59-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE59_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle58-i386$(BOX_SUFFIX): oracle58-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE58_I386)" $<

$(VIRTUALBOX_BOX_DIR)/oracle57-i386$(BOX_SUFFIX): oracle57-i386.json
	rm -rf $(VIRTUALBOX_OUTPUT)
	mkdir -p $(VIRTUALBOX_BOX_DIR)
	packer build -only=$(VIRTUALBOX_BUILDER) $(PACKER_VARS) -var "iso_url=$(ORACLE57_I386)" $<

list:
	@for box_file in $(BOX_FILES) ; do \
		echo $$box_file ; \
	done ;

clean: clean-builders clean-output clean-packer-cache
		
clean-builders:
	@for builder in $(BUILDER_TYPES) ; do \
		if test -d box/$$builder ; then \
			echo Deleting box/$$builder/*.box ; \
			find box/$$builder -maxdepth 1 -type f -name "*.box" ! -name .gitignore -exec rm '{}' \; ; \
		fi ; \
	done
	
clean-output:
	@for builder in $(BUILDER_TYPES) ; do \
		echo Deleting output-$$builder-iso ; \
		echo rm -rf output-$$builder-iso ; \
	done
	
clean-packer-cache:
	echo Deleting packer_cache
	rm -rf packer_cache

test-$(VMWARE_BOX_DIR)/%$(BOX_SUFFIX): $(VMWARE_BOX_DIR)/%$(BOX_SUFFIX)
	bin/test-box.sh $< vmware_desktop vmware_fusion $(CURRENT_DIR)/test/*_spec.rb
	
test-$(VIRTUALBOX_BOX_DIR)/%$(BOX_SUFFIX): $(VIRTUALBOX_BOX_DIR)/%$(BOX_SUFFIX)
	bin/test-box.sh $< virtualbox virtualbox $(CURRENT_DIR)/test/*_spec.rb
	
ssh-$(VMWARE_BOX_DIR)/%$(BOX_SUFFIX): $(VMWARE_BOX_DIR)/%$(BOX_SUFFIX)
	bin/ssh-box.sh $< vmware_desktop vmware_fusion $(CURRENT_DIR)/test/*_spec.rb
	
ssh-$(VIRTUALBOX_BOX_DIR)/%$(BOX_SUFFIX): $(VIRTUALBOX_BOX_DIR)/%$(BOX_SUFFIX)
	bin/ssh-box.sh $< virtualbox virtualbox $(CURRENT_DIR)/test/*_spec.rb	
