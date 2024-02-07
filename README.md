# AArch64 ARMv8/ARMv9 Instruction Set Architecture

TMS implementation in SimNML for the GLISS2 ISS generator. [Arm Architecture Reference Manual for A-profile architecture](https://developer.arm.com/documentation/ddi0487/latest).

This GLISS ISA supports ARMv8/ARMv9, 64-bits architecture, with only 32-bit instructions.

You must use [our fork of GLISS2](https://github.com/statinf-otawa/gliss2) for some critical fixes.

## Installation

GLISS2 must be available as a sibling directory:

```sh
cd ..
git clone https://github.com/statinf-otawa/gliss2
cd gliss2
make
cd ../aarch64-armv8v9
```

Then, you have just to build ISS, disassembler and libraries with:

```sh
cd ../aarch64-armv8v9
make WITH_DYNLIB=1
```

or

```sh
make
```

to enable `-fPIC`.

## Disassembler Use

You can find the disassembler in `disasm/aarch64-disasm` and run it as such

```sh
disasm/aarch64-disasm <elf64file>
```

## Implementation Status

Notation:
* [ ] -- Not implemented
* [partial] -- Partially implemented (not all masks done)
* [x] -- Disasembler implemented (no actions)

Instructions used in LTS code:

- [x] B
- [x] B.cond
- [x] BC.cond
- [x] BL
- [partial] BLR
- [partial] BLRAA
- [partial] BLRAAZ
- [partial] BLRAB
- [partial] BLRAAZ
- [partial] BR
- [partial] BRAA
- [partial] BRAAZ
- [partial] BRAB
- [partial] BRABZ