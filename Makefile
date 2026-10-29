CXX ?= g++
CXXFLAGS = -O3 -std=c++20 -march=native -Wall -Wextra -Iinclude -pthread

TARGET = build/torky-ontology-cli
PROVER_BIN = build/zero_knowledge_prover

all: $(TARGET) $(PROVER_BIN)

$(TARGET): src/torky_cli_kernel.cpp include/torky_continuum_core.hpp
	@mkdir -p build
	$(CXX) $(CXXFLAGS) src/torky_cli_kernel.cpp -o $(TARGET)

$(PROVER_BIN): src/security/zero_knowledge_prover.cpp include/torky_continuum_core.hpp
	@mkdir -p build
	$(CXX) $(CXXFLAGS) src/security/zero_knowledge_prover.cpp -o $(PROVER_BIN)

test: all
	./$(TARGET)
	./$(PROVER_BIN)
	python3 tests/test_merkle_policy.py
	./run_audit.sh

clean:
	rm -rf build local_verification_certificate.json
