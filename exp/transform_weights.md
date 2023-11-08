### ⚠️  Note: This page does not need to be read or understood to use Simple-Slices! ⚠️

# Experimental algorithm to transform weights

SystemD does not currently support aliasing slices, but another approach is to create multiple slices with the same weight. This cannot preserve the effective weight of each slice, but each weight value can be adjusted such that the difference in effective weight between each slice remains (relatively) constant after the duplication. **Note that the resources given to slices of a particular weight value will still be greater than the resources given to a single slice of that weight value before the transformation.** The transformation can be represented by the following equation (which might not render properly):

$$\frac{W_{k+1}-W_{k}}{\sum_{n=0}^{N-1}W_{n}}=\frac{A_{k+1}-A_{k}}{A_{r}+\sum_{n=0}^{N-1}A_{n}},\forall{0\le{k}\lt{N-1}}\tag{1}$$

Where $W_{n}$ is the pre-defined weight at index n of the array of all pre-defined weights, $A_{n}$ is the adjusted value of $W_{n}$, $N$ is the number of weights, and $r$ is the index of the weight to be duplicated (while maintaining the aformentioned relationship). The weights are currently transformed by multiplying each weight with a custom scaling factor, and then adding the same shift factor to all scaled weights. This can be represented by the following equation:

$$A_{n}=F_{n}W_{n}+S\tag{2},\forall{0\le{n}\lt{N-1}}$$

By (1) and (2):

$$0=(W_{k+1}-W_{k})(F_{r}W_{r}+(N+1)S)+\sum_{n=0}^{N-1}W_{n}(F_{n}(W_{k+1}-W_{k})-F_{k+1}W_{k+1}+F_{k}W_{k}),\forall{0\le{k}\lt{N-1}}\tag{3}$$

This yields $N-1$ linearly independant equations for $N+1$ linearly independant variables. Another constraint can be applied to keep any single weight value unchanged by the transformation. This is useful to (help to) remain within the bounds allowed by CGroups. This constraint can be represented as:

$$A_{z}=W_{z}\tag{4},0\le{z}\le{N-1}$$

By (2) and (4):

$$F_{z}W_{z}+S=W_{z}\Longleftrightarrow0=F_{z}W_{z}+S-W_{z}\tag{5}$$

By default, the last index of the maximum weight value is used. This leaves 1 remaining degree of freedom, which is currently used to set the shift factor to an arbitrary constant. Many different values are tried, and the one yielding the most desirable results is used.
