echo "1\n1" | gmx trjconv -f md.xtc -s md.tpr -o md_protein.xtc -center -ur compact -pbc mol
echo "1\n1" | gmx trjconv -f md.xtc -s md.tpr -o md_protein.pdb -center -ur compact -pbc mol -dump 0
echo "1" | gmx convert-tpr -s md.tpr -o md_protein.tpr
vmd md_protein.pdb md_protein.xtc
