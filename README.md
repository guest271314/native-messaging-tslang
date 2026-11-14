## TypeScript Native Compiler Native Messaging host
> [TypeScriptCompiler](https://github.com/ASDAlexander77/TypeScriptCompiler)
>
> A native ahead-of-time (AOT) and JIT compiler for TypeScript, built on LLVM/MLIR. It compiles `.ts` files directly to native executables, shared libraries and WebAssembly, or runs them on the fly via a built-in JIT — no Node.js or JavaScript runtime required.
>
> Targets: Windows, Linux, Android (`arm64-v8a`, `armeabi-v7a`, `x86_64`), WebAssembly (`wasm32`, `wasm64`).

### Install

Download from [TypeScriptCompiler releases](https://github.com/PerryTS/perry/releases/latest).

### Compile to native executable
```shell
TSLANG_LIB_PATH=/ABSOLUTE/PATH/TO/TypeScriptCompiler tslang --emit=exe --opt --opt_level=2 -o nm_tslang nm_tslang.ts
```

### Compile to WASM WASI P1 target

Using WASI-SDK `clang++`
```shell
./tslang2wasi.sh nm_tslang.ts -o nm_tslang_wasip1.wasm
```

### Installation and usage on Chrome and Chromium

1. Navigate to `chrome://extensions`.
2. Toggle `Developer mode`.
3. Click `Load unpacked`.
4. Select `native-messaging-tslang` folder.
5. Note the generated extension ID.
6. Open `nm_tslang.json` in a text editor, set `"path"` to absolute path of `nm_tslang` (native executable), or `nm_tslang.sh` (shellscript to execute `nm_tslang_wasip1.wasm` with a WASM runtime) and `chrome-extension://<ID>/` using ID from 5 in `"allowed_origins"` array; and make sure `wasmtime` is in `PATH` and `nm_tslang.sh` is executable (when executing WASM targets with a WASM runtime).
7. Copy the `nm_tslang.json` file to Chrome or Chromium configuration folder, e.g., Chromium on Linux `~/.config/chromium/NativeMessagingHosts`; Chrome dev channel on Linux `~/.config/google-chrome-unstable/NativeMessagingHosts`.
8. To test click `service worker` link in panel of unpacked extension which is DevTools for `background.js` in MV3 `ServiceWorker`, observe echo'ed message from TypeScript Native Compiler Native Messaging host. To disconnect run `port.disconnect()`.

The Native Messaging host echoes back the message passed. 

For differences between OS and browser implementations see [Chrome incompatibilities](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Chrome_incompatibilities#native_messaging).

## License
Do What the Fuck You Want to Public License [WTFPLv2](http://www.wtfpl.net/about/)
