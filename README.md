# PegasusKernel toolchains

Distribuição da toolchain usada pelo build do PegasusKernel (Exynos 850 /
A12s). Este repo é leve: o clang (~3,8 GB) não cabe no git — GitHub rejeita
arquivos maiores que 100 MB — então ele vive como asset de um
[GitHub Release](https://github.com/XhakaTK/toolchains/releases) e só é
baixado quando o build precisa.

## Conteúdo

- `fetch-clang.sh` — baixa e extrai o clang do Release para o layout AOSP
  (`clang/host/linux-x86/clang-rXXXXXX`).
- `clang/host/linux-x86/` — destino do download (ignorado pelo git).

## Versões disponíveis

| clang | LLVM | Release tag |
|---|---|---|
| r614150 | 23.0.1 (AOSP 16713961) | `clang-r614150` |

## Uso manual

```bash
./fetch-clang.sh                 # baixa o clang-r614150 padrão
./fetch-clang.sh clang-r614150   # versão explícita
```

O download é cacheado em `~/.cache/pegasus-toolchains/`, então re-criar o
diretório da toolchain não baixa de novo.

## Uso pelo kernel

O `build.sh` do PegasusKernel clona este repo em `toolchains/` e chama
`fetch-clang.sh` se `clang/host/linux-x86/clang-r614150/bin/clang` não
existir. Também dá para apontar para um clang fora do repo com
`CLANG_DIR=/caminho/do/clang bash build.sh`.
