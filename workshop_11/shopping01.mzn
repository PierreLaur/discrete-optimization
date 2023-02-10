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

array[MERCHANT, ARROW] of var 0..1 : bought_to_enable ;
array[MERCHANT, ARROW] of var 0..1 : just_bought ;
array[MERCHANT, ARROW] of var 0..1 : got_for_free ;

% link the variables
constraint forall(v in MERCHANT, a in ARROW)
        (got_for_free[v,a] + bought_to_enable[v,a] + just_bought[v,a] <= 1);

constraint forall(v in MERCHANT, a in ARROW)
        (
            how[a] <= - v * bought_to_enable[v,a]   + 5 * m * (1-bought_to_enable[v,a])
            /\ how[a] >= - v * bought_to_enable[v,a]   - 5 * m * (1-bought_to_enable[v,a])
            /\ how[a] <= v * got_for_free[v,a]         + 5 * m * (1-got_for_free[v,a])
            /\ how[a] >= v * got_for_free[v,a]         - 5 * m * (1-got_for_free[v,a])
            /\ how[a] <= 0                             + 5 * m * (1-just_bought[v,a])
            /\ how[a] >= 0 +                           - 5 * m * (1-just_bought[v,a])
        );

% assign right number of arrows to enable deal
constraint forall(v in MERCHANT)
    (sum(a in ARROW)(bought_to_enable[v,a]) >= buy[v] * used[v]);

% assign not too many arrows for free for deal
constraint forall(v in MERCHANT)
    (sum(a in ARROW)(got_for_free[v,a]) <= free[v] * used[v]);

% Ensure arrows free in deal are not more expensive than arrows bought
constraint forall(v in MERCHANT, a1,a2 in ARROW)
    (max(price) * ((1-got_for_free[v, a2]) + (1-bought_to_enable[v,a1])) >= price[a2] - price[a1]);

% buy one of each
constraint forall(a in ARROW)
    (sum(v in MERCHANT)(got_for_free[v,a]+bought_to_enable[v,a]+just_bought[v,a]) >= 1);


int: total = sum(price);
var 0..total: objective = sum(a in ARROW, v in MERCHANT)((just_bought[v,a] + bought_to_enable[v,a])*price[a]);

solve minimize objective;

output  
   ["how = "++show(how)++";\nobjective = "++show(objective)++";\n"];

