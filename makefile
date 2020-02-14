GAME_NAME = hello-world

ASM = rgbasm
LINK = rgblink
FIX = rgbfix
BGB = ../../bgb/bgb64.exe
BUILD_DIR = build

# Define sources
SRC_DIR = src
ASM_SOURCES := $(wildcard $(SRC_DIR)/*.asm)
INCLUDES = inc

# list of ASM program objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.asm=.obj)))
vpath %.asm $(sort $(dir $(ASM_SOURCES)))

all:  $(BUILD_DIR)/$(GAME_NAME).gb fix

$(BUILD_DIR)/%.obj: %.asm Makefile | $(BUILD_DIR)
	$(ASM) -i $(INCLUDES)  $< -o $@

$(BUILD_DIR):
	mkdir $@ 

$(BUILD_DIR)/$(GAME_NAME).gb: $(OBJECTS) Makefile
	$(LINK) -o $(BUILD_DIR)/$(GAME_NAME).gb $(OBJECTS)

.PHONY: fix
fix: $(BUILD_DIR)/$(GAME_NAME).gb
	$(FIX) $(BUILD_DIR)/$(GAME_NAME).gb

.PHONY: run
run: $(BUILD_DIR)/$(GAME_NAME).gb
	$(BGB) -rom $(BUILD_DIR)/$(GAME_NAME).gb

clean:
	rm -rf $(BUILD_DIR)