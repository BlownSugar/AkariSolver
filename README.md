
# Akari Puzzle Solver

## Project Overview
This project aims to provide different approaches to solving the Akari (light-up) puzzle, a logic puzzle involving placing lights to illuminate a grid. It features solvers implemented in Prolog for a depth-first search (DFS) approach and in Python using OR-Tools for various constraint satisfaction problem (CSP) solvers.


## Content Description
1. **DFS Solver in Prolog (`AkariSolver_DFS`)**: 
   - This solver uses a depth-first search algorithm to find a solution by placing lamps in valid positions on the board.
   
2. **Verifier in Prolog (`AkariVerifier`)**:
   - This component verifies the correctness of a given solution, ensuring that all cells are lit without any lamps illuminating each other.
   
3. **CSP Solvers in Python**:
   - Multiple solvers implemented using OR-Tools, each varying in terms of approach and accuracy. These solvers apply constraint satisfaction techniques to find solutions.

## Installation and Running the Solvers
- Prolog files can be run in any standard Prolog environment.
- Python scripts require OR-Tools, which can be installed via pip:
  ```bash
  pip install ortools
  ```
