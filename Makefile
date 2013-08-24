TOP_DIR = `pwd`

CC      = gcc
CCFLAGS = -g -O0 -I./include -I./include/antlr
LDFLAGS = -g -O0 -L./lib

ifeq ($(OS),Windows_NT)
RM=del
else
RM=rm -f
CFLAGS+=-fPIC
LDFLAGS+=-fPIC
endif

TARGET=pger_test
SRCS=pger_test.c
OBJS=$(SRCS:.c=.o)

ANTLR_DIR=antlr
ANTLR=$(ANTLR_DIR)/GerberLexer.c $(ANTLR_DIR)/GerberParser.c

LIBPGER=libpger.so
LIBPGER_SRCS=pger.c $(ANTLR)
LIBPGER_OBJS=$(LIBPGER_SRCS:.c=.o)

COMMON_FLAGS=

antlr_path=$(TOP_DIR)/tools/antlr-3.4-complete.jar

JAVA=java
antlrc=$(JAVA) -jar $(antlr_path)
grun=$(JAVA) org.antlr.v4.runtime.misc.TestRig

.PHONY: all clean
all: $(TARGET)
clean: ANTLR_clean $(LIBPGER)_clean $(TARGET)_clean

#-----------------------------------------

$(LIBPGER): $(LIBPGER_OBJS)
	$(CC) $(COMMON_FLAGS) $(LDFLAGS) -shared -o $@ $(LIBPGER_OBJS) -lantlr3c

$(TARGET): $(LIBPGER) $(OBJS)
	$(CC) $(COMMON_FLAGS) $(LDFLAGS) -o $@ $(OBJS) -L. $(LIBPGER) -lantlr3c

#-----------------------------------------

$(LIBPGER)_clean:
	$(RM) $(LIBPGER) $(LIBPGER_OBJS) $(LIBPGER_OBJS:.o=.d)

$(TARGET)_clean:
	$(RM) $(TARGET) $(OBJS) $(OBJS:.o=.d)

ANTLR_clean:
	$(RM) $(ANTLR) $(ANTLR:.c=.h) $(ANTLR:.c=.d) $(ANTLR_DIR)/GerberLexer.tokens

#-----------------------------------------

#%.tab.c %.tab.h: %.y
#	bison -d $<
#
#%.yy.c: %.l
#	flex -o $@ --header-file=$(@:.c=.h) $<

%.o: %.c $(DEPS)
	$(CC) -MMD -c -o $@ $< $(COMMON_FLAGS) $(CCFLAGS)

%Lexer.c %Parser.c: %.g
	$(antlrc) $<

#-----------------------------------------

-include *.d
