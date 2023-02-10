int: n; % number of arrow types
set of int: ARROW = 1..n;
array[ARROW] of int: price;   % price of each arrow type

int: m; % number of merchants
set of int: MERCHANT = 1..m;
array[MERCHANT] of int: buy;   % buy this many to use deal
array[MERCHANT] of int: free;  % get this many free

set of int: ASSIGN = -m .. m; % -i arrow is assigned to buy for deal of merchant i
                              %  i arrow is assigned as free from deal of merchant i
                              %  0 no deal used on arrow

array[ARROW] of var ASSIGN: how;
array[MERCHANT] of var bool: used;

array[MERCHANT, ARROW] of var bool : bought_to_enable ;
array[MERCHANT, ARROW] of var bool : just_bought ;
array[MERCHANT, ARROW] of var bool : got_for_free ;

constraint forall(a in ARROW)
        (sum(v in MERCHANT)(got_for_free[v,a] + bought_to_enable[v,a] + just_bought[v,a]) = 1);

constraint forall(v in 1..m, a in ARROW)
        (
            (bought_to_enable[v,a] -> (how[a] = -v)) 
            /\ (got_for_free[v,a] -> (how[a] = v)) 
            /\ (just_bought[v,a] -> (how[a] = 0))
        );

% assign right number of arrows to enable deal
constraint forall(v in MERCHANT)(sum(a in ARROW)(bought_to_enable[v,a]) <= used[v]*buy[v]);
% assign not too many arrows for free for deal
constraint forall(v in MERCHANT)(sum(a in ARROW)(got_for_free[v,a]) <= used[v]*free[v]);

% Ensure arrows free in deal are not more expensive than arrows bought
constraint forall(v in MERCHANT, a1, a2 in ARROW)((bought_to_enable[v,a1] /\ got_for_free[v,a2]) 
                                   -> price[a2] <= price[a1]);

int: total = sum(price);
var 0..total: objective = sum(v in MERCHANT, a in ARROW)((bought_to_enable[v,a]+just_bought[v,a])*price[a]);

solve minimize objective;

% output  
   % ["how = "++show(how)++";\nobjective = "++show(objective)++";\n"];




