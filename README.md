#Gromacs Tutorial

This tutorial will guide you through the setup and execution of a molecular dynamics simulation. You should have a basic understanding of working with the command line, preferably with bash under linux.

#Introduction

Our starting point is a small peptide named [KIGAKI]3 in reference to its amino acid sequence. [KIGAKI]3 is a model peptide for protein aggregation in the presence of membranes. It possesses no defined secondary structure in solution but adopts a conformation that appears to maximize amphipathic character upon interacting with lipid bilayers. It possesses a large positive charge and therefore it interacts strongly with the negative charged headgroups of membrane lipids. [KIGAKI]3 was designed to form β-sheets when bound to membranes. [KIGAKI]3 is used in this tutorial, as it is a small peptide with interesting behaviour and larger proteins would take too much time to simulate for a short tutorial session. More info on [KIGAKI]3.

#Outline

This tutorial will guide you through several stages needed to perform a molecular dynamics (MD) simulation, from the initial setup to the final data anlysis.