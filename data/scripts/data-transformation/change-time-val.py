with open('/home/thomas/graphs/knowledge-graph-nmbs.nt', 'r') as sfile:
    filedata = sfile.read()

filedata = filedata.replace('\"0:', '\"00:')
filedata = filedata.replace('\"24:', '\"00:')
# filedata = filedata.replace('\"01:', '\"1:')
# filedata = filedata.replace('\"02:', '\"2:')
# filedata = filedata.replace('\"03:', '\"3:')
# filedata = filedata.replace('\"04:', '\"4:')
# filedata = filedata.replace('\"05:', '\"5:')
# filedata = filedata.replace('\"06:', '\"6:')
# filedata = filedata.replace('\"07:', '\"7:')
# filedata = filedata.replace('\"08:', '\"8:')
# filedata = filedata.replace('\"09:', '\"9:')


with open('/home/thomas/graphs/knowledge-graph-nmbs.nt', 'w') as dfile:
    dfile.write(filedata)