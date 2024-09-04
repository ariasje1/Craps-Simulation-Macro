****** Jesus Arias 
	   Project 4 ******;


%macro simulate_craps(strategy, num_games=1000, seed=12345, output=temp, path=, dataset_name=craps_results, summary=yes);

    %let rand_seed = &seed;
    %let game_data = &dataset_name;

    %if &output = perm %then %let game_data = &path..&dataset_name;

    %if &strategy = simple %then %do;
        data &game_data;
            length result $4;
            call streaminit(&rand_seed);
            do game = 1 to &num_games;
                die1 = rand("Integer", 1, 6);
                die2 = rand("Integer", 1, 6);
                total = die1 + die2;

                if total in (7, 11) then result = 'Win';
                else if total in (2, 3, 12) then result = 'Loss';
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
    %else %if &strategy = mod3 %then %do;
        data &game_data;
            length result $4;
            call streaminit(&rand_seed);
            do game = 1 to &num_games;
                die = rand("Integer", 1, 12); /* Single 12-sided die */
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
    %else %do;
        %put ERROR: Invalid strategy specified. Please choose 'simple', 'mod1', 'mod2', or 'mod3';
        %return;
    %end;

    /* Create summary table*/
    %if &summary = yes %then %do;
        proc freq data=&game_data;
            tables result / nocum nopercent;
            title "Summary of &num_games Games using Strategy &strategy";
        run;
    %end;

%mend simulate_craps;


%simulate_craps(strategy=simple, num_games=1000, seed=9876, output=perm, path=work, dataset_name=simple_results, summary=yes);
%simulate_craps(strategy=mod1, num_games=1000, seed=9876, output=perm, path=work, dataset_name=mod1_results, summary=yes);
%simulate_craps(strategy=mod2, num_games=1000, seed=9876, output=perm, path=work, dataset_name=mod2_results, summary=yes);
%simulate_craps(strategy=mod3, num_games=1000, seed=9876, output=perm, path=work, dataset_name=mod3_results, summary=yes);
