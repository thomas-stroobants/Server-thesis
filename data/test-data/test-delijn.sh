#!/usr/bin/bash

# Set the FTP server address and port
sftp_server="transfer.delijn.be"
sftp_port=22

# Set the FTP username and password
sftp_user="TAP-SFTP-GTFS00105"
sftp_pass="soBpBIiQWZOc3jupQlqe"

# Set the remote directory and local directory
remote_dir="/Public/*.zip"
local_dir="$HOME/data/test-data"

# Download the files using the sftp command and sshpass
sshpass -p $sftp_pass sftp -oPort=$sftp_port $sftp_user@$sftp_server <<EOF
get -r $remote_dir $local_dir
exit
EOF
echo "Files downloaded successfully!"