#!/bin/bash

# Prepare topology file of kigaki peptide

echo "6" | gmx pdb2gmx -f kigaki.pdb -o kigaki.gro -p kigaki.top -i kigaki_posre.itp -water tip3p -ignh
gmx editconf -f kigaki.gro -o kigaki_box.gro -bt dodecahedron -d 1.0

# Add water into the simulation box

gmx solvate -cp kigaki_box.gro -cs spc216.gro -o kigaki_solvated.gro -p kigaki.top

# Add ion into the water

gmx grompp -f ions.mdp -po ions.out.mdp -c kigaki_solvated.gro -p kigaki.top -o ions.tpr -maxwarn 1
echo "13" | gmx genion -s ions.tpr -o kigaki_ions.gro -p kigaki.top -pname NA -nname CL -neutral -conc 0.1

# Energy minimization

gmx grompp -f em.mdp -po em.out.mdp -c kigaki_ions.gro -p kigaki.top -o em.tpr -maxwarn 1
gmx mdrun -v -nt 1 -ntmpi 1 -deffnm em > em.out

# Equilibration MD

gmx grompp -f eq.mdp -po eq.out.mdp -c em.gro -t em.trr -p kigaki.top -o eq.tpr -r em.gro -maxwarn 1
gmx mdrun -v -nt 1 -ntmpi 1 -deffnm eq > eq.out

# Production MD

gmx grompp -f md.mdp -po md.out.mdp -c eq.gro -t eq.trr -p kigaki.top -o md.tpr -maxwarn 1
gmx mdrun -v -nt 1 -ntmpi 1 -deffnm md > md.out
