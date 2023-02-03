# Bash script to automate the data retrieval and conversion process, including loading data into Virtuoso
echo "----------------------------------------------"
echo "$(date) | Start of data retrieval static data"
# Download the static data
$HOME/data/scripts/data-retrieval/get-data.sh

# Activate virtual environment for Python
echo "$(seba)"

# Change departuretimes from time format to ISO dateTime
python3 $HOME/data/scripts/data-transformation/connect-datetime.py &
pid_nmbs=$!
python3 $HOME/data/scripts/data-transformation/connect-datetime-dl.py &
pid_dl=$!
echo "$(date) | Waiting for PID NMBS ($pid_nmbs) and De Lijn ($pid_dl) to finish"

wait $pid_nmbs $pid_dl
echo "$(date) | data transformation complete"

echo "$(date) | transforming iRail data"
python3 $HOME/data/scripts/data-transformation/replace-irail.py