# Makefile for Seanime build automation
# Provides common development and build tasks

.PHONY: all build run test clean generate lint help

# Go binary name
BINARY_NAME=seanime
BUILD_DIR=./build
MAIN_PACKAGE=./cmd/main.go

# Version info from git
GIT_COMMIT=$(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_TAG=$(shell git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# Linker flags
LD_FLAGS=-ldflags "-X main.Version=$(GIT_TAG) -X main.Commit=$(GIT_COMMIT) -X main.BuildDate=$(BUILD_DATE)"

# Default target
all: build

## build: Compile the application for the current platform
build:
	@echo "Building $(BINARY_NAME) $(GIT_TAG) ($(GIT_COMMIT))..."
	@mkdir -p $(BUILD_DIR)
	go build $(LD_FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PACKAGE)
	@echo "Build complete: $(BUILD_DIR)/$(BINARY_NAME)"

## build-linux: Cross-compile for Linux (amd64)
build-linux:
	@echo "Building for Linux amd64..."
	@mkdir -p $(BUILD_DIR)
	GOOS=linux GOARCH=amd64 go build $(LD_FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 $(MAIN_PACKAGE)

## build-windows: Cross-compile for Windows (amd64)
build-windows:
	@echo "Building for Windows amd64..."
	@mkdir -p $(BUILD_DIR)
	GOOS=windows GOARCH=amd64 go build $(LD_FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe $(MAIN_PACKAGE)

## build-darwin: Cross-compile for macOS (arm64)
build-darwin:
	@echo "Building for macOS arm64..."
	@mkdir -p $(BUILD_DIR)
	GOOS=darwin GOARCH=arm64 go build $(LD_FLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 $(MAIN_PACKAGE)

## run: Run the application in development mode
run:
	@echo "Running $(BINARY_NAME)..."
	go run $(MAIN_PACKAGE)

## test: Run all tests
test:
	@echo "Running tests..."
	go test ./... -v -timeout 120s

## test-short: Run tests excluding long-running integration tests
test-short:
	@echo "Running short tests..."
	go test ./... -short -timeout 60s

## lint: Run linter
lint:
	@echo "Running linter..."
	@which golangci-lint > /dev/null || (echo "golangci-lint not found, install it from https://golangci-lint.run/" && exit 1)
	golangci-lint run ./...

## generate: Run go generate for all packages
generate:
	@echo "Running go generate..."
	go generate ./...

## tidy: Tidy go modules
tidy:
	@echo "Tidying go modules..."
	go mod tidy

## clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete."

## release-notes: Generate release notes for the latest tag
release-notes:
	@echo "Generating release notes for $(GIT_TAG)..."
	go run .github/scripts/generate_release_notes.go

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^## ' Makefile | sed 's/## /  /'
