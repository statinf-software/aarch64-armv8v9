#
# ARMv8A -- GLISS2 implementation of ARMv8A
# Copyright (C) 2024  STATINF
#

# configuration
GLISS_PREFIX	= ../gliss2

-include config.mk

# definitions
ARCH=aarch64
ifdef WITH_DYNLIB
REC_FLAGS = WITH_DYNLIB=1
endif

GFLAGS= \
	-m loader:old_elf64 \
	-m code:code \
	-m env:void_env \
	-m sys_call:extern/sys_call \
	-v \
	-a disasm.c \
	-S \
	-switch \
	-D \

GFLAGS += -m mem:vfast_mem64

MAIN_NMP	=	$(ARCH).nmp

NMP = \
	nmp/$(MAIN_NMP) \
	# nmp/state.nmp \
	# nmp/condition.nmp \
	# nmp/control.nmp \
	# nmp/dataProcessingMacro.nmp \
	# nmp/dataProcessing.nmp \
	# nmp/exception.nmp \
	# nmp/fp.nmp  \
	# nmp/loadstore.nmp \
	# nmp/loadStoreM.nmp \
	# nmp/loadStoreM_Macro.nmp \
	# nmp/modes.nmp \
	# nmp/mult.nmp \
	# nmp/shiftedRegister.nmp \
	# nmp/simpleType.nmp \
	# nmp/syntax_macros.nmp \
	# nmp/system.nmp \
	# nmp/tempVar.nmp \
	# nmp/coproc.nmp

# goals definition
GOALS		=
SUBDIRS		=	src
CLEAN		=	$(ARCH).nml $(ARCH).irg
DISTCLEAN	=	include src $(CLEAN) config.mk
LIB_DEPS	=	include/$(ARCH)/config.h

GFLAGS		+=	-a used_regs.c
LIB_DEPS	+=	src/used_regs.c

ifdef WITH_DISASM
GOALS		+=	$(ARCH)-disasm
SUBDIRS		+=	disasm
DISTCLEAN	+= 	disasm
GFLAGS		+= -a disasm.c
LIB_DEPS	+= src/disasm.c 
endif

# rules
all: lib $(GOALS)

$(ARCH).irg: $(NMP)
	cd nmp &&  ../$(GLISS_PREFIX)/irg/mkirg $(MAIN_NMP) ../$@  && cd ..

src include: $(ARCH).irg
	$(GLISS_PREFIX)/gep/gep $(GFLAGS) $<

lib: src $(LIB_DEPS)
	(cd src; make $(REC_FLAGS))

$(ARCH)-disasm:
	cd disasm; make

include/$(ARCH)/config.h: config.tpl
	test -d src || mkdir src
	cp config.tpl $@

src/disasm.c: $(ARCH).irg
	$(GLISS_PREFIX)/gep/gliss-disasm $(ARCH).irg -o $@ -c

src/used_regs.c: $(ARCH).irg nmp/used_regs.nmp
	$(GLISS_PREFIX)/gep/gliss-used-regs $< -e nmp/used_regs.nmp

clean:
	rm -rf $(CLEAN)

distclean:
	rm -Rf $(DISTCLEAN) $(ARCH).irg $(ARCH).out

config.mk:
	cp default.mk config.mk
