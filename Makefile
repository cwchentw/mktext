#!/bin/sh

# Program metadata.
PROG=$0
VERSION=0.1.0
LICENSE=MIT

# Get the path of `make` utility.
MAKE=`which make`

# Extract first parameter as action.
ACTION=$1; shift;

# Parse arguments for the actions *filter* and *select*.
if [ "$ACTION" == "allOf" ] || [ "$ACTION" == "any" ] \
	|| [ "$ACTION" == "filter" ] || [ "$ACTION" == "select" ]; then
	COND=$1; shift;
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
	@printf "\tallOf cond arg_a arg_b arg_c ...\n"
	@printf "\tany cond arg_a arg_b arg_c ...\n"
	@printf "\tfilter cond arg_a arg_b arg_c ...\n"
	@printf "\tselect cond arg_a arg_b arg_c ...\n"
	@printf "\tsort arg_a arg_b arg_c ...\n"
	@printf "\tsub from to arg_a arg_b arg_c ...\n"
	@echo ""
	@echo "Parameters:"
	@printf "\t-v,--version\tShow version number\n"
	@printf "\t--license\tShow licesing message\n"
	@printf "\t-h,--help\tShow help message\n"
endef

define check
	if \$(1); then \
		true; \
	else \
		""; \
	fi
endef

# Remove duplicated Makefile targets.
PARAMETERS=-v --version -h --help --license
ACTIONS=allOf any filter select sort sub
GOALS=\$(filter-out \$(PARAMETERS) \$(ACTIONS), \$(MAKECMDGOALS))

EMPTY=
COMMA=\$(empty),\$(empty)
SPACE=\$(empty) \$(empty)
NEWLINE=\\n

.PHONY: all unknown \$(PARAMETERS) \$(ACTIONS) \$(GOALS)

all: unknown

-v --version:
	@echo $VERSION

--license:
	@echo $LICENSE

-h --help:
	\$(help)

\$(GOALS) unknown:
	@echo "Unknown action"
	\$(help)

allOf: PRED := \$(strip \$(filter-out true,\$(foreach v,$@,\$(if \$(filter \$(v),$COND),true,false))))
allOf:
	@if [ -z "\$(PRED)" ]; then \
		echo true; \
	else \
		echo false; \
	fi

any: PRED := \$(strip \$(filter-out false,\$(foreach v,$@,\$(if \$(filter \$(v),$COND),true,false))))
any:
	@if ! [ -z "\$(PRED)" ]; then \
		echo true; \
	else \
		echo false; \
	fi

filter:
	@printf "\$(subst \$(SPACE),\$(NEWLINE),\$(filter-out $COND,$@))\n"

select:
	@printf "\$(subst \$(SPACE),\$(NEWLINE),\$(filter $COND,$@))\n"

sort:
	@printf "\$(subst \$(SPACE),\$(NEWLINE),\$(sort $@))\n"

sub:
	@printf "\$(subst \$(SPACE),\$(NEWLINE),\$(subst $FROM,$TO,$@))\n"

END
