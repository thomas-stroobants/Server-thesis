with open('../graphs/knowledge-graph-nmbs.nt', 'r') as sfile:
    filedata = sfile.read()

filedata = filedata.replace('\"00:', '\"0:')

with open('../graphs/knowledge-graph-nmbs.nt', 'w') as dfile:
    dfile.write(filedata)