#!/bin/sh
PROG=mktext
VERSION=0.1.0
MAKE=`which make`
ACTION=$1; shift;

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

ARGS=\$(filter-out -v --version -h --help sub,\$(MAKECMDGOALS))

SPACE=\$(empty) \$(empty)
NEWLINE=\\n

.PHONY: all unknown -v --version -h --help unknown sub \$(ARGS)

all: \$(ARGS) unknown

-v --version:
	@echo $VERSION

-h --help:
	\$(help)

\$(ARGS) unknown:
	@echo "Unknown action"
	\$(help)

sub:
	@printf "\$(subst \$(SPACE),\$(NEWLINE),\$(subst $FROM,$TO,$@))\n"

END
