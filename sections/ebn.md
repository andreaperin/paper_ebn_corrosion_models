# Enhanced Bayesian Network Framework (eBN) for Risk Assessment


#### Main Elements
- An eBN is a direct acyclic graphs defined by 2 main elements:
    - nodes, which represents events and are defined through a Conditional Probability Table (CPT). Nodes can be discrete when their possible states are in a finite number and their CPT has crisp probability values associted to these states. On the other hand continuous nodes have infinite possible states and their CPT is identified by one or more Univariate Distributions.
    - Edges, representing a direct dipendence between 2 nodes. The nodes where the edge start is called parent while the one the edge is pointing to is called child.
- Nodes without any parents are called Root Nodes. All the non-root nodes of a network have a CPT with scenarios defined by the combination of the states of all their discrete parents.
-  
#### Main Features

- Keep all the advantages of traditional BN:
    - Multi-scenario analysis
    - Act as multi-disciplinary aggregator of informtion
    - Offer a direct visual representation of complex problem
    - Express complex relationship among events to simpler parents/children relationship
    - Allow the usage of exact inference algorithm to perform both prognosis and diagnosis analysis
- Add the possibility to deal with aleatoric uncertainties:
    - Introduces continuous nodes, i.e. nodes defined through Univariate Distributions and not discrete Conditional Probability Table (CPTs)
    - Exploits Structural Reliability Methods (SRPs) to peform the evaluation of the system join probability measure with nodes defined by Univariate Distribution/s, since this problem has the same mathematical expression of Structural Reliability Problem.
    - Uses both exact and approximated Discretization algorithm to be able to take into account evidences over continuous nodes.
