try
{
    ssh -L 42069:localhost:42069 pcsgs02 'source /data/scratch/forschungsprojekt/config/main.sh && jupyter lab --no-browser --port=42069'
}

finally
{
    ssh pcsgs02 'pkill -u $USER -f jupyter'
}
