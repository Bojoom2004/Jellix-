.PHONY: test sim mips
CORE=core/jx_cfg.c core/jx_input.c core/jx_thumb.c core/jx_catalog.c core/jx_log.c core/jx_profile.c
GFX=core/jx_gfx.c core/jx_home.c
CFLAGS=-std=c99 -Wall -Wextra -Werror
test:
	gcc $(CFLAGS) -fsanitize=address,undefined -g -o /tmp/jx_test tests/test_core.c tests/test_gfx.c $(CORE) $(GFX) && /tmp/jx_test
sim:
	gcc $(CFLAGS) -fsanitize=address,undefined -g -o /tmp/jx_sim sim/sim_main.c $(GFX)
# проверка сборки под MIPS24KEc (little-endian, как ActSDK): только компиляция
mips:
	for f in $(CORE) $(GFX); do clang --target=mipsel-unknown-elf -march=mips32r2 -mno-abicalls -fno-pic -ffreestanding -nostdinc -isystem stub -isystem $(shell clang -print-resource-dir)/include -O2 -Wall -Wextra -Werror -c $$f -o /tmp/$$(basename $$f .c).mips.o || exit 1; done; (llvm-size /tmp/jx_*.mips.o 2>/dev/null || size /tmp/jx_*.mips.o)
