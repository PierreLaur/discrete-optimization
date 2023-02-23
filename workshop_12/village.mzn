include "globals.mzn";
% Warning the village
int: n; % number of houses
set of int: HOUSE = 1..n; 
array[HOUSE] of int: x;
array[HOUSE] of int: y;
int: limit; % max time allowed
function var int : distance(var HOUSE : h1, var HOUSE : h2) = 
        abs(x[h1]-x[h2]) + abs(y[h1]-y[h2]);


int: m; % number of messengers
set of int: MESSENGER = 1..m;
array[MESSENGER] of var HOUSE: messenger; % who are the messengers
array[HOUSE] of var bool : is_messenger;
constraint forall(h in HOUSE)(is_messenger[h]<->exists(i in messenger)(i=h));

% nodes
% 1..N are villagers
% n+1..n+m are end trip node
set of int: NODE = 1..n+m;
array[NODE] of var NODE: next;   % next node visited after this one
var 0..limit: endtime;

constraint alldifferent(messenger);

% dummies
constraint forall(i in 1..m-1)(next[n+i]=messenger[i+1]);
constraint next[n+m] = messenger[1];
constraint circuit(next);

% warned
array[0..limit, HOUSE] of var bool : warned ;
constraint row(warned,0)=is_messenger;
constraint forall(t in 1..limit, h in HOUSE)
            (warned[t,h] -> warned[t-1,h] \/
                    exists(h2 in HOUSE)                    
                    (let {var int : dist = distance(h2,h)} in if t-dist>=0 then 
                        (warned[t-dist,h2] /\ next[h2]=h) else false endif));
constraint forall(t in 0..limit where t>=endtime, h in HOUSE)(warned[t,h]);

% Symmetry breaking
constraint increasing(messenger);

include "gecode.mzn";

solve
        % ::bool_search(array1d(warned), dom_w_deg, indomain_max)
        ::int_search(array1d(next), dom_w_deg, indomain_random)
        ::restart_luby(10)
        ::relax_and_reconstruct(next, 80)
        minimize endtime ;

output[show(messenger)]++["\n"];
output[show(next)]++["\n"];
output[show(endtime)]++["\n"];



% constraint messenger = [7, 5, 10];
% constraint next = [11, 13, 6, 12, 9, 4, 3, 2, 8, 1, 5, 10, 7];
% constraint endtime = 16;