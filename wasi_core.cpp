// wasi_core.cpp
// Satisfies the WASI _start entry point (tslang runs top-level code via
// .init_array before main()), routes binary stdio to wasi-libc for tslang (TypeScript Native Compiler)
// guest271314 11-14-2026

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern "C" {

// Binary stdio hooks expected by tslang's defaultlib
int32_t stdio_read(void* buf, int32_t len) {
  if (!buf || len <= 0)
    return 0;
  return (int32_t)fread(buf, 1, (size_t)len, stdin);
}

int32_t stdio_write_bytes(int32_t fd, const void* buf, int32_t len) {
  if (!buf || len <= 0)
    return 0;
  FILE* stream = (fd == 2) ? stderr : stdout;
  size_t written = fwrite(buf, 1, (size_t)len, stream);
  fflush(stream);
  return (int32_t)written;
}

// Matches tslang's (i32) -> void signature to avoid trapping against
// wasi-libc's (i32) -> i64
void time(int32_t* t) {
  if (t)
    *t = 0;
}
}
// WASI entry point: .init_array executes tslang's top-level code before main()
int main(int argc, char** argv) {
  return 0;
}
