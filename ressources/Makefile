LIB = @ \
	. ../lib/lib.sh;

default:
	@ \
	printf '%s\n' "targets:"; \
	cat ./Makefile | \
	grep '^[^ 	]\+:' | \
	sed 's|:$$||g'

.PHONY: