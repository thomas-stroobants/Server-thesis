import morph_kgc
import requests
import subprocess

nmbs_url = "https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de"
nmbs_rt_url = "https://sncb-opendata.hafas.de/gtfs/realtime/c21ac6758dd25af84cca5b707f3cb3de"



def download_files(url, file_name):
    response = requests.get(url)
    open(file_name, "wb").write(response.content)
    print(f"Content downloaded to {file_name}.")

def unzip_file(file_name, dst_folder):
    subprocess.run(["unzip", file_name, "-d", dst_folder])

download_files(nmbs_rt_url, "nmbs-rt-data/nmbs-rt-proto")