#!/bin/bash
#PBS -l host=cheddar
#PBS -l mem=40gb
#PBS -l walltime=168:00:00
cd $PBS_O_WORKDIR
sas snippet20.sas  -memsize 40G
