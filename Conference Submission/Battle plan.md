Title:
* Discovering the Dynamical System governing the evolution of temporal networks via RDPG embedding and Neural Differential Equations

Plan:
  - Introduction (Connor)
    - Modelling the temporal networks evolution is hard, you know it
    - Discovering the equations governing it is even harder
    - Nodes can influence each other, so it would be nice to use diffeq systems, but changes in networks are jumps, so hard to model
    - Example of possible applications
    - RDPG embedding is well established in Statistics, and nets as dynsys
  - Methodology (GVDR)
    - RDPG, Svd embedding
      - PLOT of temporal sequence, embeddings
        G1, G2, G3, ..., Gt, -> Gt+1
        E1, E2, E3, ..., Et, -> Et+1
        `---------|--------'
                Dx/Dt = ...  -> Et+1
                                Gt+1
    - NDE
    - SciML
    - Symbolic Regression
    - Mention we have a package going on.
  - Data (Connor)
    - Synthetic
    - Plot of graphs
  - Results
    - Does it work? How well?
  - Discussion / Conclusion
    - Limits: performance and accuracy: we are introducing the idea, it remains to be optimised
    - Future: optimise, scale up, maybe UDE?, applications
