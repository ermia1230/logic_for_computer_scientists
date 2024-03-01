read_data :-
    see('/Users/ermiaghaffari/Desktop/Prolog/Ass2/test1.txt'),  % Open the file for reading
    read(Term),       % Read a term from the file
    read(You),
    read(Term1),
    seen,             % Close the file
    writeln(Term).      % Write the term to the console
    writeln(You),      % Write the term to the console
    writeln(Term1).   
    