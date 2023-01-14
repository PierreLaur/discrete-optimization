- **Valuation** :  
    - a mapping variables -> values  
    - valuation $\theta$ $\in$ D if $\theta$(X) in D(X) for every X var 
    - A **solution** is a valuation which satisfies every constraint

- **Constraints**
    - formally : sets of valuations

- **Propagators** :  
    - Function D -> D' *monotonically decreasing*, reduces the domains  
    - **Correct** for constraint c <-> never removes a value that occurs in a solution  
    - **Checking** for constraint c <-> if all variables are fixed, returns {} unless it is a solution  

    - **Domain Propagators** remove all values that don't take part in a solution (strongest propagators)
    - $\sum$aX+b=Y propagation is NP-Hard
    - $\sum$aX+b$\leq$Y propagation is linear

