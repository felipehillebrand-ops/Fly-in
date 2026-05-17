PYTHON		= python3
VENV		= .venv
SRC_DIR		= src
MAIN		= $(SRC_DIR)/main.py
PIP			= $(VENV)/bin/pip
PYTEST		= $(VENV)/bin/pytest
FLAKE8		= $(VENV)/bin/flake8
MYPY		= $(VENV)/bin/mypy

MAP			?= maps/easy/01_linear_path.txt
 
all: install
 
install:
	@echo ">>> Creating virtual environment..."
	$(PYTHON) -m venv $(VENV)
	@echo ">>> Installing dependencies..."
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@echo ">>> Installation complete."
 
run:
	@echo ">>> Running Fly-in simulation..."
	$(VENV)/bin/python3 $(MAIN) $(MAP)
 
debug:
	@echo ">>> Running Fly-in simulation in debug mode..."
	$(VENV)/bin/python3 -m pdb $(MAIN) $(MAP)

clean:
	@echo ">>> Cleaning temporary files..."
	find . -type d -name "__pycache__"   -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache"   -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc"         -delete 2>/dev/null || true
	find . -type f -name "*.pyo"         -delete 2>/dev/null || true
	@echo ">>> Clean complete."
 
fclean: clean
	@echo ">>> Removing virtual environment..."
	rm -rf $(VENV)
	@echo ">>> Full clean complete."

lint:
	@echo ">>> Running flake8..."
	$(FLAKE8) .
	@echo ">>> Running mypy..."
	$(MYPY) . \
		--warn-return-any \
		--warn-unused-ignores \
		--ignore-missing-imports \
		--disallow-untyped-defs \
		--check-untyped-defs
	@echo ">>> Lint complete."
 
lint-strict:
	@echo ">>> Running flake8 (strict)..."
	$(FLAKE8) .
	@echo ">>> Running mypy (strict)..."
	$(MYPY) . --strict
	@echo ">>> Strict lint complete."
 
test:
	@echo ">>> Running tests..."
	$(PYTEST) tests/ -v

help:
	@echo ""
	@echo "  Fly-in — Drone Routing Simulation"
	@echo ""
	@echo "  Targets:"
	@echo "    install      Install project dependencies into a virtual environment"
	@echo "    run          Run the simulation  (pass MAP=<map_file> for a specific map)"
	@echo "    debug        Run the simulation with Python's pdb debugger"
	@echo "    clean        Remove __pycache__, .mypy_cache, .pytest_cache, *.pyc"
	@echo "    fclean       clean + remove the virtual environment"
	@echo "    lint         Run flake8 + mypy with mandatory flags"
	@echo "    lint-strict  Run flake8 + mypy with --strict"
	@echo "    test         Run unit tests with pytest"
	@echo ""
	@echo "  Example:"
	@echo "    make run MAP=maps/easy_1.txt"
	@echo ""

.PHONY: all install run debug clean fclean lint lint-strict test help