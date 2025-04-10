# Enhanced Bayesian Network Framework (eBN) for Risk Assessment

#### Risk Assessment
- Why risk assessment is important?
  - important especially for safety-critical system, which are becoming more spread all the world
  - important for avoiding design and operational failures
  - important for the definition of adequate safety criteria and not being always too conservative
  - A reliable risk assessments must driven the selection procedure to preclude catastrophic events, such as the Piper Alpha offshore oil disaster, the Seveso industrial accident, or the Clapham Junction rail crash
  
- Which are the main features required by a risk assessment analysis?
  - accurate 
  - accounting for different scenarios
  - accounting for uncertainties 
  - accounting for information quality and completeness 
  - a tool that can drive in a reliable way the decision-making process
  - but accuracy alone is not enough cause it generally requires a trade-off with computational cost
   
- Which are traditional tool to perform risk assement?
  - Fault Tree \ Event Tree are effective in diagnosis problem but are limited to a Boolean logic, and are not suitable for prognosis puroposes
  - BN, direct acyclic graph based on parent-child relationships
  - BN, also known as belief networks can be seen a generalized FT, no more limited by boolean logic, capable of performing both prognosis and diagnosis through exact inferenxe algorithm, inherently usefull for Risk Assessment since most of the probabilities experts are seeking are conditional probability, and BNs provide and efficient factorization of system join probability through conditional probabilities.
  
- What are the advantages of using enhanced Bayesian Network for risk assesment?
  - BN cannot deal with aleatoric uncertainties, are not suitable to reach small probabilities values since they rely on the expert knowledge 
  - eBN are a tool that exploits traditional structural reliability methods such as MonteCarlo FORM and Avanced MonteCarlo to introduce aleatoric uncertainties into traditional BN in the form of nodes defined through univariate distributions
