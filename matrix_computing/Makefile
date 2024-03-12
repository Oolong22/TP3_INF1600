CPP_SRCS := $(wildcard *.cpp)
ASM_SRCS := $(wildcard *.S)
ASM_OBJ := $(ASM_SRCS:.S=.o)
CPP_OBJ := $(CPP_SRCS:.cpp=.o)

CXXFLAGS := -lm -gdwarf-2 -Wall
ASMFLAGS := -fno-pie -no-pie
SHARED_FLAG := -m32 -g
CXX := g++

TARGET := out

.PHONY: all clean run

all: $(TARGET)

$(ASM_OBJ): %.o: %.S
	$(CXX) $(SHARED_FLAG) -c -o $@ $< $(ASMFLAGS)

$(CPP_OBJ): %.o: %.cpp 
	$(CXX) $(SHARED_FLAG) -c -o $@ $^ $(CXXFLAGS)

$(TARGET): $(ASM_OBJ) $(CPP_OBJ)
	$(CXX) $(CXXFLAGS) $(SHARED_FLAG) $(ASMFLAGS) -o $@ $^

clean:
	rm -f $(TARGET) *.o

run: $(TARGET)
	@echo
	./$(TARGET)
	@echo