#!/bin/bash
#PBS -l host=cheddar
#PBS -l mem=4gb
#PBS -l walltime=168:00:00
cd $PBS_O_WORKDIR
sas snippet25.sas  -memsize 4G
