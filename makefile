.DEFAULT_GOAL := bin/byte

# Compiler and flags
CXX      := g++
CXXFLAGS := -std=c++11 -MMD -MP

# Directories
BINDIR       := bin
OBJDIR       := obj
SRCDIR       := src
TEST_OUTPUT_DIR := test_output

# Source files (explicitly listed)
SRCS    := byte.cpp lexer.cpp
SOURCES := $(addprefix $(SRCDIR)/, $(SRCS))
OBJECTS := $(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(SOURCES))
DEPS    := $(OBJECTS:.o=.d)

# Build the target executable
$(BINDIR)/byte: $(OBJECTS) | $(BINDIR)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJECTS)

# Pattern rule for object files
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(OBJDIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Generate lexer.cpp from lexer.l
$(SRCDIR)/lexer.cpp: $(SRCDIR)/lexer.l $(SRCDIR)/token.h $(wildcard $(SRCDIR)/*.h)
	flex -p -o $@ -i $<

# Ensure lexer.cpp is built before compiling lexer.o
$(OBJDIR)/lexer.o: $(SRCDIR)/lexer.cpp

# Create directories if they don't exist
$(BINDIR) $(OBJDIR):
	mkdir -p $@

# Clean generated files and directories
.PHONY: clean
clean:
	rm -rf $(BINDIR) $(OBJDIR) $(SRCDIR)/lexer.cpp *.s

# Test target
.PHONY: test
test: $(BINDIR)/byte
	mkdir -p $(TEST_OUTPUT_DIR)
	$(BINDIR)/byte < mg.f24 > $(TEST_OUTPUT_DIR)/output.txt

# Include dependency files
-include $(DEPS)