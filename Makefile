
MCU = 32MZ1024EFG064
FORMAT = ihex
TARGET = test
SRC = main.c

PROGRAMMER = PPK3
IPE_CMD = ipecmd
IPE_FLAGS = -T$(PROGRAMMER) -P$(MCU) -OL

CC = xc32-gcc
OBJCOPY = xc32-objcopy
OBJDUMP = xc32-objdump
BIN2HEX = xc32-bin2hex
SIZE = xc32-size
NM = xc32-nm
RM = rm -f

# debug format
DEBUG = 
# C-standard
CSTANDARD = gnu99
# optimization level
OPT = 0

# compiler flags
CFLAGS = -mprocessor=$(MCU) -g$(DEBUG) -x c -O$(OPT) -std=$(CSTANDARD) -ffunction-sections -fdata-sections -no-legacy-libc

# linker flags
#  -Wl,...:     tell GCC to pass this to linker.
#     -Map:     create map file
#   --cref:     add cross reference to  map file
LDFLAGS = -mprocessor=$(MCU) -no-legacy-libc
LDFLAGS += -Wl,--defsym=_min_heap_size=0,--gc-sections,--no-code-in-dinit,--no-dinit-in-serial-mem,-Map=$(TARGET).map,--cref

# sources to objects
OBJ = $(SRC:.c=.o) $(ASRC:.S=.o) 

# default target
all: build

build: elf hex size

elf: $(TARGET).elf
hex: $(TARGET).hex

size:
	$(SIZE) --target=$(FORMAT) $(TARGET).hex

program: $(TARGET).hex
	$(IPE_CMD) $(IPE_FLAGS) -M -F$(TARGET).hex

# compile: create object files from C source files.
%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

# link: create elf output file from object files.
.SECONDARY : $(TARGET).elf
.PRECIOUS : $(OBJ)
%.elf: $(OBJ)
	$(CC) $(LDFLAGS) $(OBJ) -o $@

# create final output file (.hex) from elf
%.hex: %.elf
	$(BIN2HEX) $<

.PHONY : all build hex size program clean

clean:
	$(RM) log.*
	$(RM) $(TARGET).map
	$(RM) $(TARGET).elf
	$(RM) $(TARGET).hex
	$(RM) $(OBJ)
	$(RM) MPLABXLog.xml*
