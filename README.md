# eBPF Go Playground

This repository is based on Liz Rice's "Beginner's Guide to eBPF Programming with Go" talk (GOTO 2021).

Original talk: https://www.youtube.com/watch?v=uBqRv8bDroc&t
Original repository: https://github.com/lizrice/libbpfgo-beginners

I recreated the example locally to:
- Understand how libbpfgo works
- Explore how BPF programs are compiled with clang
- Experiment with Dockerized build environments
- Debug libbpf version mismatches on modern Ubuntu

## What I changed / explored

- Added Docker helper targets to Makefile
- Investigated libbpf API changes across versions
- Compared host vs container builds
- Documented perf_buffer API mismatch issues