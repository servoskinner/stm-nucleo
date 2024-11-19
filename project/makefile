#-----------------------
# Compiler/linker flags
#-----------------------

CC = arm-none-eabi-gcc

SRC_DIR = 	source \
			source/hardware \
			source/periph \
			source/structs 
INCL_DIR = 	include \
			include/hardware \
			include/periph \
			include/structs
BUILD_DIR = build

CFLAGS = \
	-mcpu=cortex-m4 \
	-mthumb \
	$(foreach dir, $(INCL_DIR), -I$(dir))

LDFLAGS = \
	-nostdlib \
	-mcpu=cortex-m4 \
	-Wl,-T,entry.lds \

ifeq ($(DEBUG),1)
	CFLAGS += -g
endif

ifeq ($(QEMU),1)
	CFLAGS += -g -DINSIDE_QEMU
endif

#-------
# Files
#-------

SOURCES = $(shell find $(SRC_DIR) -maxdepth 1 -name '*.c') \
		  $(shell find $(SRC_DIR) -maxdepth 1 -name '*.S') \
		  logic.c

OBJECTS = $(patsubst %.S, $(BUILD_DIR)/%.o, $(patsubst %.c, $(BUILD_DIR)/%.o, $(SOURCES)))

EXECUTABLE_FLASH = $(BUILD_DIR)/program.elf
BINARY_FLASH     = $(BUILD_DIR)/program.bin

#---------------
# Build scripts
#---------------

all: $(EXECUTABLE_FLASH) $(BINARY_FLASH)

$(EXECUTABLE_FLASH): $(OBJECTS)
	@echo
	@echo $(SOURCES)
	@echo
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

$(BINARY_FLASH): $(EXECUTABLE_FLASH)
	@mkdir -p $(dir $@)
	arm-none-eabi-objcopy -O binary $< $@

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ -c $<

$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	rm -rf $(BUILD_DIR)

#----------------------
# Hardware interaction
#----------------------

QEMU_FLAGS = \
	-machine NUCLEO-F411RE \
	-cpu cortex-m4 \
	-kernel $(EXECUTABLE_FLASH) \
	-serial stdio \
	-m 32M \
	-icount 25 \
	-gdb tcp::1234 \

GDB_FLAGS = \
	--eval-command="set architecture arm" \
	--eval-command="set gnutarget elf32-littlearm" \
	--eval-command="target remote localhost:1234" \
	--eval-command="file $(EXECUTABLE_FLASH)"

flash: $(BINARY_FLASH)
	st-flash write $(BINARY_FLASH) 0x08000000

qemu: $(EXECUTABLE_FLASH)
	qemu-system-gnuarmeclipse $(QEMU_FLAGS)

hardware: $(EXECUTABLE_FLASH)
	st-util -p 1234

gdb: $(BINARY_FLASH)
	arm-none-eabi-gdb $(GDB_FLAGS)

.PHONY: all clean flash qemu hardware gdb