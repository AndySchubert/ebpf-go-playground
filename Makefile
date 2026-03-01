ARCH=$(shell uname -m)

TARGET := hello
TARGET_BPF := $(TARGET).bpf.o

GO_SRC := *.go
BPF_SRC := *.bpf.c

LIBBPF_HEADERS := /usr/include/bpf
LIBBPF_OBJ := /usr/lib/$(ARCH)-linux-gnu/libbpf.a

.PHONY: all
all: $(TARGET) $(TARGET_BPF)

go_env := CC=clang CGO_CFLAGS="-I $(LIBBPF_HEADERS)" CGO_LDFLAGS="$(LIBBPF_OBJ)"
$(TARGET): $(GO_SRC)
	$(go_env) go build -o $(TARGET) 

$(TARGET_BPF): $(BPF_SRC)
	clang \
		-I /usr/include/$(ARCH)-linux-gnu \
		-O2 -c -target bpf \
		-o $@ $<

.PHONY: clean
clean:
	go clean

# -----------------------------
# Docker helpers (tutorial flow)
# -----------------------------

.PHONY: docker-build docker-shell docker-run docker-clean docker-chown

docker-build:
	docker build -t $(DOCKER_IMAGE) .

# Interactive shell in the container (useful for debugging / manual runs)
docker-shell:
	docker run --rm -it --privileged \
		-v "$$PWD:/app" \
		-v /sys/kernel/debug:/sys/kernel/debug \
		-v /lib/modules:/lib/modules:ro \
		--entrypoint /bin/bash \
		$(DOCKER_IMAGE)

# Clean, rebuild, and run inside the container in one command
docker-run:
	docker run --rm -it --privileged \
		-v "$$PWD:/app" \
		-v /sys/kernel/debug:/sys/kernel/debug \
		-v /lib/modules:/lib/modules:ro \
		--entrypoint /bin/bash \
		$(DOCKER_IMAGE) \
		-lc "make clean && make && ./$(TARGET)"

# Remove artifacts from the repo (host side)
docker-clean: clean

# Fix root-owned files created by container builds (run on host)
docker-chown:
	sudo chown -R $$USER:$$USER .