#!/bin/bash
#PBS -l host=cheddar
#PBS -l mem=4gb
#PBS -l walltime=24:00:00
cd $PBS_O_WORKDIR
sas snippet10.sas  -memsize 4G
