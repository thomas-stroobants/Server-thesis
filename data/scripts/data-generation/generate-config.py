## Python script to generate the configuration files for morph-kgc
import sys
import configparser
import os
import getopt

#argument parser for info about parameters
def argumentcheck(argv):
    arg_config = "config-generated.ini"
    arg_mapping = ""
    arg_output = "knowledge-graph.nt"
    arg_logging = "morph-log-kg.log"
    arg_processes = 1
    arg_help = f"Usage for command: {argv[0]} -c <config_file> -m <mapping_file> -o <output_file> -l <logging_file> -p <num_of_processes>"

    #check if all arguments are given
    try:
        opts, agrs = getopt.getopt(argv[1:], "hc:m:o:l:p:", ["help", "config=", "mapping=", "output=", "logging=", "processes="])
    except:
        print(arg_help)
        sys.exit(2)

    #storing arguments in variables
    for opt,arg in opts:
        if opt in ("-h", "--help"):
            print(arg_help)  # print the help message
            sys.exit(2)
        elif opt in ("-c", "--config"):
            arg_config = arg
        elif opt in ("-m", "--mapping"):
            arg_mapping = arg
        elif opt in ("-o", "--output"):
            arg_output = arg
        elif opt in ("-l", "--logging"):
            arg_logging = arg
        elif opt in ("-p", "--processes"):
            arg_processes = arg

    print("Configuration for .ini file:")
    print(f"\tconfig: {arg_config}")
    print(f"\tmapping: {arg_mapping}")
    print(f"\toutput: {arg_output}")
    print(f"\tlogging: {arg_logging}")
    print(f"\tprocesses: {arg_processes}")
    return arg_config, arg_mapping, arg_output, arg_logging, arg_processes

def constructConfig(configfile, mapping, outputfile, loggingfile, processes):
    configsection = 'CONFIGURATION'
    datasource = 'Datasource1'
    outputpath = '/home/thomas/graphs'
    logpath = '/home/thomas/graphs/log'
    mappingpath = '/home/thomas/data/rml'
    configpath = '/home/thomas/graphs/config'

    config = configparser.ConfigParser(allow_no_value=True)

    config.add_section(configsection)
    config.add_section(datasource)

    config.set(configsection, '# INPUT')
    config.set(configsection, 'na_values', ',#N/A,N/A,#N/A N/A,n/a,NA,<NA>,#NA,NULL,null,NaN,nan,None')
    config.set(configsection, '# OUTPUT')
    config.set(configsection, 'output_file', os.path.join(outputpath, outputfile))
    config.set(configsection, 'output_format', 'N-TRIPLES')
    config.set(configsection, 'only_printable_characters', 'no')

    config.set(configsection, '# MAPPINGS')
    config.set(configsection, 'mapping_partitioning', 'MAXIMAL')

    config.set(configsection, '# MULTIPROCESSING')
    config.set(configsection, 'number_of_processes', processes)

    config.set(configsection, '# LOGS')
    config.set(configsection, 'logging_level', 'DEBUG')
    config.set(configsection, 'logging_file', os.path.join(logpath, loggingfile))

    config.set(datasource, 'mappings', os.path.join(mappingpath, mappingfile))

    with open(os.path.join(configpath, configfile), 'w+') as cfp:
        config.write(cfp)

if __name__ == "__main__":
    configfile, mappingfile, outputfile, loggingfile, processesnum = argumentcheck(sys.argv)
    constructConfig(configfile, mappingfile, outputfile, loggingfile, processesnum)
