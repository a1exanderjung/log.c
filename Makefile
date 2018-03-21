LIB_NAME   := log
SRC_DIR    := src
BUILD_DIR  := build

SRC_FILES  := $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES  := $(SRC_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

LIB_ST_EXT := a
LIB_DY_EXT := so

# Platform-specific overrides
PLATFORM := $(shell sh -c 'uname -s 2>/dev/null || echo not')
ifeq ($(PLATFORM), Darwin)
LIB_DY_EXT = dylib
endif

LIB_ST_NAME = lib$(LIB_NAME).$(LIB_ST_EXT)
LIB_DY_NAME = lib$(LIB_NAME).$(LIB_DY_EXT)

CC = gcc
CC_FLAGS = -Wall -Wextra -fPIC -O3 -g -ggdb

.PHONY: all
all: $(BUILD_DIR) $(OBJ_FILES) $(LIB_ST_NAME) $(LIB_DY_NAME)

$(BUILD_DIR):
	@mkdir -p $@

$(OBJ_FILES): $(SRC_FILES)
	$(CC) -o $*.o -c $(CC_FLAGS) $<

$(LIB_DY_NAME): $(OBJ_FILES)
	$(CC) -shared -o $(LIB_DY_NAME) $^

$(LIB_ST_NAME): $(OBJ_FILES)
	ar rcs $(LIB_ST_NAME) $^

.PHONY: clean
clean:
	@rm -Rfv $(BUILD_DIR)
	@rm -fv $(LIB_ST_NAME)
	@rm -fv $(LIB_DY_NAME)
