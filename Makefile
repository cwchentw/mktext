#!/bin/sh

# Program metadata.
PROG=mktext
VERSION=0.1.0
LICENSE=MIT

# Get the path of `make` utility.
MAKE=`which make`

# Extract first parameter as action.
ACTION=$1; shift;

if [ "$ACTION" == "select" ]; then
	COND=$1; shift;
fi

if [ "$ACTION" == "sub" ]; then
	FROM=$1; shift;
	TO=$1; shift;
fi

cat << END | $MAKE -f - -- $ACTION
define help
	@echo "Usage: $PROG action ..."
	@echo ""
	@echo "Actions:"
	@printf "\tsub from to text_a text_b text_c ...\n"
	@echo ""
	@echo "Parameters:"
	@printf "\t-v,--version\tShow version number\n"
	@printf "\t-h,--help\tShow help message\n"
endef

ARGS=\$(filter-out -v --version -h --help select sub,\$(MAKECMDGOALS))

SPACE=\$(empty) \$(empty)
NEWLINE=\\n

.PHONY: all unknown -v --version -h --help select sub \$(ARGS)

all: \$(ARGS) unknown

-v --version:
	@echo $VERSION

-h --help:
	\$(help)

\$(ARGS) unknown:
	@echo "Unknown action"
	\$(help)

select:
	@printf "\$(subst \$(SPACE),\$(NEWLINE),\$(filter $COND,$@))\n"

sub:
	@printf "\$(subst \$(SPACE),\$(NEWLINE),\$(subst $FROM,$TO,$@))\n"

END
