#!/bin/bash
#PBS -l mem=4gb
#PBS -l walltime=96:00:00
cd $PBS_O_WORKDIR
sas snippet7.sas  -memsize 4G
