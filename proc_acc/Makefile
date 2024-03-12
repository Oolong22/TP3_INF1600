C_SRCS := $(wildcard *.c)
ASM_SRCS := $(wildcard *.s *.S)
ASM_OBJ := $(ASM_SRCS:.s=.o)
C_OBJ := $(C_SRCS:.c=.o)

CFLAGS := -lm -gdwarf-2
ASMFLAGS := -fno-pie -no-pie
SHARED_FLAG := -m32
CC := gcc
EDITOR := editor.cm
DBG := gdb

TARGET := out

.PHONY: all clean run

all: $(TARGET)

$(ASM_OBJ): %.o: %.s
	$(CC) -g -c -o $@ $< $(SHARED_FLAG) $(ASMFLAGS)

$(C_OBJ): %.o: %.c
	$(CC) -c -o $@ $< $(SHARED_FLAG) $(CFLAGS)

$(TARGET): $(ASM_OBJ) $(C_OBJ)
	$(CC) -g -o $@ $^ $(SHARED_FLAG) $(CFLAGS) $(ASMFLAGS)

clean:
	rm -f $(TARGET) *.o

run: $(TARGET)
	@echo
	./$(TARGET) $(EDITOR)
	@echo

debug: $(TARGET)
	$(DBG) ./$(TARGET) -ex="set args $(EDITOR)"
	