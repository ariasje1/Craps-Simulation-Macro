/****** 
Author: Jesus Arias
GitHub username: ariasje1
Date: 09/04/2024
Description: This SAS macro simulates the game of Craps using various strategies and generates datasets with the results of each simulation. 
             It includes options for customizing the number of games and provides summary statistics for each strategy.
******/

/**
 * Macro to Simulate the Game of Craps
 * 
 * @param strategy       - The strategy to use for simulating the game. Accepts 'simple', 'mod1', 'mod2', or 'mod3'.
 * @param num_games      - The number of games to simulate. Default is 1,000,000.
 * @param seed           - The seed value for random number generation to ensure reproducibility. Default is 12345.
 * @param output         - Specifies whether the dataset will be temporary ('temp') or permanent ('perm'). Default is 'temp'.
 * @param path           - The path to save the permanent dataset. Ignored if output is 'temp'.
 * @param dataset_name   - The name of the dataset to be created. Default is 'craps_results'.
 * @param summary        - Specifies whether to create a summary table of the results. Accepts 'yes' or 'no'. Default is 'yes'.
 */

%macro simulate_craps(strategy, num_games=1000000, seed=12345, output=temp, path=, dataset_name=craps_results, summary=yes);

    /* Initialize local macro variables */
    %let rand_seed = &seed; /* Random seed for reproducibility */
    %let game_data = &dataset_name; /* Default dataset name */

    /* If output is permanent, set the dataset name with the specified path */
    %if &output = perm %then %let game_data = &path..&dataset_name;

    /* Strategy: Simple (Basic Craps Rules) */
    %if &strategy = simple %then %do;
        data &game_data;
            length result $4; /* Result column length */
            call streaminit(&rand_seed); /* Initialize random number generator */
            
            /* Simulate games */
            do game = 1 to &num_games;
                /* Roll two 6-sided dice */
                die1 = rand("Integer", 1, 6);
                die2 = rand("Integer", 1, 6);
                total = die1 + die2;

                /* Check initial roll outcome */
                if total in (7, 11) then result = 'Win';
                else if total in (2, 3, 12) then result = 'Loss';
                else do;
                    /* Set the point and continue rolling */
                    point = total;
                    do while(1);
                        die1 = rand("Integer", 1, 6);
                        die2 = rand("Integer", 1, 6);
                        total = die1 + die2;

                        /* Check for win or loss */
                        if total = point then do;
                            result = 'Win';
                            leave;
                        end;
                        else if total = 7 then do;
                            result = 'Loss';
                            leave;
                        end;
                    end;
                end;
                output; /* Output the result for each game */
            end;
        run;
    %end;

    /* Strategy: Modified 1 (Alternative Ruleset 1) */
    %else %if &strategy = mod1 %then %do;
        data &game_data;
            length result $4;
            call streaminit(&rand_seed);
            
            do game = 1 to &num_games;
                die1 = rand("Integer", 1, 6);
                die2 = rand("Integer", 1, 6);
                total = die1 + die2;

                if total in (7, 10) then result = 'Win';
                else if total in (2, 3, 11, 12) then result = 'Loss';
                else do;
                    point = total;
                    do while(1);
                        die1 = rand("Integer", 1, 6);
                        die2 = rand("Integer", 1, 6);
                        total = die1 + die2;

                        if total = point then do;
                            result = 'Win';
                            leave;
                        end;
                        else if total = 7 then do;
                            result = 'Loss';
                            leave;
                        end;
                    end;
                end;
                output;
            end;
        run;
    %end;

    /* Strategy: Modified 2 (Alternative Ruleset 2) */
    %else %if &strategy = mod2 %then %do;
        data &game_data;
            length result $4;
            call streaminit(&rand_seed);
            
            do game = 1 to &num_games;
                die1 = rand("Integer", 1, 6);
                die2 = rand("Integer", 1, 6);
                total = die1 + die2;

                if total in (6, 8) then result = 'Win';
                else if total in (2, 7, 12) then result = 'Loss';
                else do;
                    point = total;
                    do while(1);
                        die1 = rand("Integer", 1, 6);
                        die2 = rand("Integer", 1, 6);
                        total = die1 + die2;

                        if total = point or total in (2, 12) then do;
                            result = 'Win';
                            leave;
                        end;
                        else if total in (6, 8) then do;
                            result = 'Loss';
                            leave;
                        end;
                    end;
                end;
                output;
            end;
        run;
    %end;

    /* Strategy: Modified 3 (Single 12-Sided Die) */
    %else %if &strategy = mod3 %then %do;
        data &game_data;
            length result $4;
            call streaminit(&rand_seed);
            
            do game = 1 to &num_games;
                /* Roll a single 12-sided die */
                die = rand("Integer", 1, 12); 
                total = die;

                if total in (13, 23) then result = 'Win';
                else if total in (2, 3, 24) then result = 'Loss';
                else do;
                    point = total;
                    do while(1);
                        die = rand("Integer", 1, 12);
                        total = die;

                        if total = point then do;
                            result = 'Win';
                            leave;
                        end;
                        else if total = 13 then do;
                            result = 'Loss';
                            leave;
                        end;
                    end;
                end;
                output;
            end;
        run;
    %end;

    /* Error Handling for Invalid Strategy */
    %else %do;
        %put ERROR: Invalid strategy specified. Please choose 'simple', 'mod1', 'mod2', or 'mod3';
        %return;
    %end;

    /* Create Summary Table if Specified */
    %if &summary = yes %then %do;
        proc freq data=&game_data;
            tables result / nocum nopercent;
            title "Summary of &num_games Games using Strategy &strategy";
        run;
    %end;

%mend simulate_craps;

/* Run the macro with different strategies */
%simulate_craps(strategy=simple, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=simple_results, summary=yes);
%simulate_craps(strategy=mod1, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=mod1_results, summary=yes);
%simulate_craps(strategy=mod2, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=mod2_results, summary=yes);
%simulate_craps(strategy=mod3, num_games=1000000, seed=9876, output=perm, path=work, dataset_name=mod3_results, summary=yes);
