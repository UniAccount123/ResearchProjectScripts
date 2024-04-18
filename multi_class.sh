export BFP=/data/scratch/forschungsprojekt
export PLSSVM=$BFP/plssvm-develop

module load cuda/12.0.1

export MANPATH=$MANPATH:${PLSSVM}/share/man
export PATH=$PATH:${PLSSVM}/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PLSSVM}/lib
export PYTHONPATH=$PYTHONPATH:${PLSSVM}/lib

source $BFP/envs/jupyter/bin/activate

cd $BFP
