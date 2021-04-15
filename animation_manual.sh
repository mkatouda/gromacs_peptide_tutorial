gmx trjconv -f md.xtc -s md.tpr -o md_protein.xtc -center -ur compact -pbc mol
gmx trjconv -f md.xtc -s md.tpr -o md_protein.pdb -center -ur compact -pbc mol -dump 0
gmx convert-tpr -s md.tpr -o md_protein.tpr
vmd md_protein.pdb md_protein.xtc
