#!/bin/bash

#PBS -l select=1:ncpus=12:mpiprocs=6:ompthreads=2:jobtype=core
#PBS -l walltime=00:30:00

N_MPI=6
N_OMP=2

module load gromacs/2020.6/intel
#module load scl/devtoolset-9 intel_parallelstudio/2019update5
#source ~/bin/x86_64/gromacs/2020.6/intel/bin/GMXRC.bash

if [ ! -z "${PBS_O_WORKDIR}" ]; then
  cd "${PBS_O_WORKDIR}"
fi

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
mpirun -n ${N_MPI} gmx_mpi mdrun -v -ntomp ${N_OMP} -deffnm em > em.out

# Equilibration MD

gmx grompp -f eq.mdp -po eq.out.mdp -c em.gro -t em.trr -p kigaki.top -o eq.tpr -r em.gro -maxwarn 1
mpirun -n ${N_MPI} gmx_mpi mdrun -v -ntomp ${N_OMP} -deffnm eq > eq.out

# Production MD

gmx grompp -f md.mdp -po md.out.mdp -c eq.gro -t eq.trr -p kigaki.top -o md.tpr -maxwarn 1
mpirun -n ${N_MPI} gmx_mpi mdrun -v -ntomp ${N_OMP} -deffnm md > md.out
