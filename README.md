# Craps Simulation Macro in SAS

This repository contains a SAS macro to simulate the game of Craps using various strategies. The macro allows customization of the number of games, random seed, output format, and dataset name, and provides summary statistics for each strategy's results.

## Features

- **Simulate Craps Games**: Simulate up to 1,000,000 games of Craps using different predefined strategies.
- **Customizable Parameters**: Adjust the number of games, random seed, output type (temporary or permanent), and dataset name.
- **Multiple Strategies**: Choose from four different strategies (`simple`, `mod1`, `mod2`, `mod3`) to alter the rules and gameplay.
- **Summary Statistics**: Automatically generates a summary table for each simulation to display the win/loss results.

## Usage

To use the macro, simply include it in your SAS program and call it with your desired parameters. Below is an example of how to run simulations for each strategy:

```sas
%simulate_craps(strategy=simple, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=simple_results, summary=yes);
%simulate_craps(strategy=mod1, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=mod1_results, summary=yes);
%simulate_craps(strategy=mod2, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=mod2_results, summary=yes);
%simulate_craps(strategy=mod3, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=mod3_results, summary=yes);
