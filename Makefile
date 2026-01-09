# =======================================
# Makefile for C and C++ projects
# =======================================

# ===== Macro for printing info =====
# PRINT: print a header (MSG1) in blue, then print each token of MSG2 on its own grey line prefixed with " -> "
# Args: $1 = header/title, $2 = space-separated list (or string) to print line-by-line
define PRINT
    MSG1=$$(echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$$//'); \
    MSG2=$$(echo "$2" | sed 's/^[[:space:]]*//;s/[[:space:]]*$$//'); \
    printf "$(_BLUE)%s\n" "$$MSG1"; \
    echo "$$MSG2" | tr ' ' '\n' | while IFS= read -r line; do \
        [ -n "$$line" ] && printf "$(_GREY) -> $(_NC)%s\n" "$$line"; \
    done; \
    echo
endef

# ===== Colors =====
_GREY   = \033[1;30m
_RED    = \033[1;31m
_GREEN  = \033[1;32m
_YELLOW = \033[1;33m
_BLUE   = \033[1;34m
_PURPLE = \033[1;35m
_CYAN   = \033[1;36m
_WHITE  = \033[1;37m
_NC     = \033[0m

SUCCESS   = $(_GREEN)SUCCESS[✔]$(_NC)
COMPILING = $(_BLUE)COMPILING[●]$(_NC)
WARNING   = $(_YELLOW)WARNING[⚠]$(_NC)

# ===== Project =====
NAME = a.out

# ===== Directories =====
SRCDIR      = src
INCDIR      = ./include
LIBDIR      = 
OBJDIR_ROOT = obj
BINDIR      = bin

# ===== Compiler =====
CC  = gcc
CXX = g++
AR  = ar rcs

# ===== Flags =====
FLAGS    = -Wall -Wextra -Werror -pedantic-errors
CFLAGS   = -std=c11   $(FLAGS)
CXXFLAGS = -std=c++17 $(FLAGS)
DEPFLAGS = -MMD -MP
LDFLAGS  = 
IFLAGS   = -I$(INCDIR)

# ===== Source files =====
SRC =   main.cpp \
		$(shell find $(SRCDIR) -type f -name "*.c") \
		$(shell find $(SRCDIR) -type f -name "*.cc") \
		$(shell find $(SRCDIR) -type f -name "*.cpp")

# ===== Build type =====
# r/R   = Release;
# d/D   = Debug;
# as/AS = ASan;

BUILD_TYPE ?= r
MODE := $(shell echo $(BUILD_TYPE) | tr '[:upper:]' '[:lower:]')

ifeq ($(MODE), r)
	TYPE = release
	CFLAGS   += -O2 -DNDEBUG
	CXXFLAGS += -O2 -DNDEBUG
else ifeq ($(MODE), d)
	TYPE = debug
	CFLAGS   += -g3 -O0
	CXXFLAGS += -g3 -O0
else ifeq ($(MODE), as)
	TYPE = ASan
	CFLAGS   += -g3 -O0 -fsanitize=address
	CXXFLAGS += -g3 -O0 -fsanitize=address
	LDFLAGS  += -fsanitize=address
else
$(error Unknown BUILD_TYPE '$(MODE)'. Use 'd/D for Debug, r/R for Release, as/AS for ASan')
endif

# ===== Final Object files directory =====
OBJDIR = $(OBJDIR_ROOT)/$(TYPE)

# ===== Final Object Executable file =====
EXE = $(BINDIR)/$(TYPE)/$(NAME)

# ===== Object files =====
OBJ =   $(patsubst %.c,$(OBJDIR)/%.o,$(filter %.c,$(SRC))) \
		$(patsubst %.cc,$(OBJDIR)/%.o,$(filter %.cc,$(SRC))) \
		$(patsubst %.cpp,$(OBJDIR)/%.o,$(filter %.cpp,$(SRC)))

# ===== Default target =====
all: pretty $(EXE)

# ===== Linking =====
$(EXE) : $(OBJ)
	@echo
	@echo "$(_CYAN)Creating Executable $(_WHITE)$(_NC)"
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "$(SUCCESS)\n$(_WHITE)Linked $@"

# ===== Compile rules =====
$(OBJDIR)/%.o: %.c Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[$(_CYAN)$(CC)$(_WHITE)][$(_PURPLE)$(TYPE)$(_WHITE)] [$(_YELLOW)$<$(_WHITE)] → $(_GREEN)$@$(_NC)"
	@$(CC) $(CFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR)/%.o: %.cc Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[$(_CYAN)$(CXX)$(_WHITE)][$(_PURPLE)$(TYPE)$(_WHITE)] [$(_YELLOW)$<$(_WHITE)] → $(_GREEN)$@$(_NC)"
	@$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

$(OBJDIR)/%.o: %.cpp Makefile
	@mkdir -p $(@D)
	@echo "$(COMPILING) $(_WHITE)[$(_CYAN)$(CXX)$(_WHITE)][$(_PURPLE)$(TYPE)$(_WHITE)] [$(_YELLOW)$<$(_WHITE)] → $(_GREEN)$@$(_NC)"
	@$(CXX) $(CXXFLAGS) $(DEPFLAGS) $(IFLAGS) -c $< -o $@

# ===== Auto-include dependency files =====
-include $(OBJ:.o=.d)

# ===== Run Program =====
.PHONY: run
run: all
	@echo "$(_WHITE)Running $(EXE)...$(_NC)"
	@./$(EXE)

# ===== Cleaning =====
.PHONY: clean
clean:
	@rm -rf $(OBJDIR_ROOT)
	@echo "$(_YELLOW)[-] Removed object files$(_NC)"

.PHONY: fclean
fclean: clean
	@rm -rf $(BINDIR)
	@echo "$(_RED)[x] Removed executable$(_NC)"

.PHONY: re
re: fclean all
	@echo "$(_GREEN)[✔] Rebuild complete$(_NC)"

# ===== Show info =====

.PHONY: show
show: show_src
show: show_obj
show: show_compilers
show: show_flags
show: show_include_flags
show: show_link_flags

.PHONY: show_src
show_src:
	@$(call PRINT,"Source Files:","$(SRC)")

.PHONY: show_obj
show_obj:
	@$(call PRINT,"Release Objects:","$(OBJ)")

.PHONY: show_compilers
show_compilers:
	@$(call PRINT,"C Compilers:","$(CC)")
	@$(call PRINT,"C++ Compilers:","$(CXX)")

.PHONY: show_flags
show_flags:
	@$(call PRINT,"Release CFlags:","$(CFLAGS)")
	@$(call PRINT,"Release CXXFlags:","$(CXXFLAGS)")

.PHONY: show_include_flags
show_include_flags:
	@$(call PRINT,"Include Flags:","$(IFLAGS)")

.PHONY: show_link_flags
show_link_flags:
	@$(call PRINT,"Release Link Flags:","$(LDFLAGS))

# ===== Beautify output =====
.PHONY: pretty
pretty:
	@echo "$(_CYAN)=============================$(_NC)"
	@echo "$(_CYAN) Building $(NAME) Project$(_NC)"
	@echo "$(_CYAN)=============================$(_NC)"
