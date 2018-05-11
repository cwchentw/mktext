#!/bin/sh

# Program metadata.
PROG=$0
VERSION=0.1.0
LICENSE=MIT

# Get the path of `make` utility.
MAKE=`which make`

# Extract first parameter as action.
ACTION=$1; shift;

# Parse arguments for the actions *all*, *any*, *filter* and *select*.
if [ "$ACTION" == "all" ] || [ "$ACTION" == "any" ] \
	|| [ "$ACTION" == "filter" ] || [ "$ACTION" == "select" ]; then
	COND=$1; shift;
fi

# Parse arguments for the actions *nth*.
if [ "$ACTION" == "nth" ]; then
	NTH=$1; shift;
else
	NTH=1
fi

# Parse arguments for the action *sub*.
if [ "$ACTION" == "sub" ]; then
	FROM=$1; shift;
	TO=$1; shift;
fi

cat << END | $MAKE -f - -- $ACTION
define help
	@echo "Usage: $PROG action ..."
	@echo ""
	@echo "Actions:"
	@printf "\tall cond arg_a arg_b arg_c ...\n"
	@printf "\tany cond arg_a arg_b arg_c ...\n"
	@printf "\tfilter cond arg_a arg_b arg_c ...\n"
	@printf "\tfirst arg_a arg_b arg_c ...\n"
	@printf "\tnth n arg_a arg_b arg_c ...\n"
	@printf "\tselect cond arg_a arg_b arg_c ...\n"
	@printf "\tsort arg_a arg_b arg_c ...\n"
	@printf "\tsub from to arg_a arg_b arg_c ...\n"
	@echo ""
	@echo "Parameters:"
	@printf "\t-v,--version\tShow version number\n"
	@printf "\t--license\tShow licesing message\n"
	@printf "\t-h,--help\tShow help message\n"
endef

# Remove duplicated Makefile targets.
PARAMETERS=-v --version -h --help --license
ACTIONS=all any filter first nth select sort sub
GOALS=\$(filter-out \$(PARAMETERS) \$(ACTIONS), \$(MAKECMDGOALS))

SPACE=\$(empty) \$(empty)
NEWLINE=\\\\n

.PHONY: default unknown \$(PARAMETERS) \$(ACTIONS) \$(GOALS)

# Default target when no active action.
default: unknown

-v --version:
	@echo $VERSION

--license:
	@echo $LICENSE

-h --help:
	\$(help)

# Default action when no or unknown action.
\$(GOALS) unknown:
	@echo "Unknown action"
	\$(help)

all: PRED := \
	\$(strip \
		\$(filter-out true,\
			\$(foreach v,$@,\
				\$(if \$(filter \$(v),$COND),\
					true,\
					false))))
all:
	@if [ -z "\$(PRED)" ]; then \
		echo true; \
	else \
		echo false; \
	fi

any: PRED := \
	\$(strip \
		\$(filter-out false,\
			\$(foreach v,$@,\
				\$(if \$(filter \$(v),$COND),\
					true,\
					false))))
any:
	@if ! [ -z "\$(PRED)" ]; then \
		echo true; \
	else \
		echo false; \
	fi

filter: OUT := \
	\$(strip \
		\$(subst \$(SPACE),\$(NEWLINE),\
			\$(filter-out $COND,$@)))
filter:
	@if ! [ -z \$(OUT) ]; then \
		printf "\$(OUT)\n"; \
	else \
		printf ""; \
	fi

first: OUT := \
	\$(strip \
		\$(firstword $@))
first:
	@if ! [ -z \$(OUT) ]; then \
		printf "\$(OUT)\n"; \
	else \
		printf ""; \
	fi

nth: OUT := \
	\$(strip \
		\$(word $NTH, $@))
nth:
	@if ! [ -z \$(OUT) ]; then \
		printf "\$(OUT)\n"; \
	else \
		printf ""; \
	fi

select: OUT := \
	\$(strip \
		\$(subst \$(SPACE),\$(NEWLINE),\
			\$(filter $COND,$@)))
select:
	@if ! [ -z \$(OUT) ]; then \
		printf "\$(OUT)\n"; \
	else \
		printf ""; \
	fi

sort: OUT := \
	\$(strip \
		\$(subst \$(SPACE),\$(NEWLINE),\
			\$(sort $@)))
sort:
	@if ! [ -z \$(OUT) ]; then \
		printf "\$(OUT)\n"; \
	else \
		printf ""; \
	fi

sub: OUT := \
	\$(strip \
		\$(subst \$(SPACE),\$(NEWLINE),\
			\$(subst $FROM,$TO,$@)))
sub:
	@if ! [ -z \$(OUT) ]; then \
		printf "\$(OUT)\n"; \
	else \
		printf ""; \
	fi

END
