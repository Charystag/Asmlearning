# Makefile in order to simplify the assembling and linking of files

AS := as

LD := ld

SHELL = /bin/sh

SRC_DIR := src

OBJ_DIR := obj

BIN_DIR := bin

MK := mkdir -p

.SUFFIXES:
.SUFFIXES: .s .o 

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(BIN_DIR)/% : $(OBJ_DIR)/%.o | $(BIN_DIR)
	$(LD) $(LDFLAGS) $< -o $@

$(OBJ_DIR) $(BIN_DIR):
	$(MK) $@

clean:
	$(RM) -r $(BIN_DIR)

fclean: clean
	$(RM) -r $(OBJ_DIR)
