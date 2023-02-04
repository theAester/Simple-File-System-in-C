# Target programs
programs := test-fs.x

# User-level thread library
UTHREADLIB=libuthread
libuthread := $(UTHREADLIB)/$(UTHREADLIB).a

# Default rule
all: $(libuthread) $(programs)

# Assignement
README.html:

# Avoid builtin rules and variables
MAKEFLAGS += -rR

# Don't print the commands unless explicitely requested with `make V=1`
ifneq ($(V),1)
Q = @
V = 0
endif

# Current directory
CUR_PWD := $(shell pwd)

# Define compilation toolchain
CC	= gcc

# General gcc options
CFLAGS	:= -Wall -Werror 
CFLAGS	+= -O2
#CFLAGS	+= -O0
CFLAGS	+= -g
CFLAGS	+= -pthread
CFLAGS	+= -pipe
CFLAGS	+= -lm

# Include path
INCLUDE := -I$(UTHREADLIB)

# Generate dependencies
DEPFLAGS = -MMD -MF $(@:.o=.d)

# Application objects to compile
objs := $(patsubst %.x,%.o,$(programs))

# Include dependencies
deps := $(patsubst %.o,%.d,$(objs))
-include $(deps)

# Rule for libuthread.a
$(libuthread):
	@echo "MAKE	$@"
	$(Q)$(MAKE) V=$(V) -C $(UTHREADLIB)

# Generic rule for linking final applications
%.x: %.o $(libuthread)
	@echo "LD	$@"
	$(Q)$(CC) $(CFLAGS) -o $@ $< -L$(UTHREADLIB) -luthread

# Generic rule for compiling objects
%.o: %.c
	@echo "CC	$@"
	$(Q)$(CC) $(CFLAGS) $(INCLUDE) -c -o $@ $< $(DEPFLAGS)

# Generic rule for markdown
%.html: %.md
	@echo "MKDN	$@"
	$(Q)pandoc -s --toc -o $@ $<

# Cleaning rule
clean:
	@echo "CLEAN	$(CUR_PWD)"
	$(Q)$(MAKE) V=$(V) -C $(UTHREADLIB) clean
	$(Q)rm -rf $(objs) $(deps) $(programs) README.html

.PHONY: clean $(libuthread)

