------------------------------------
steps to be taken:

- test loading data into virtuoso --> see if rt data updates static data times
- test query data in virtuoso
- setup automation for retrieving rt data and loading into virtuoso

- testing steps above on oxigraph/RDFLib

- create skill for user to ask data
- test/improve skill

- test performance of virtuoso on RPI

- create benchmarks to record time for data retrieval

- come up with rew research questions 
- come up with title for thesis


Virtuoso Open Source Edition (Column Store) 7.2.8 configuration summary
=======================================================================

Installation variables
  layout                  Debian
  prefix                  /usr
  exec_prefix             ${prefix}

Installation paths
  programs                ${exec_prefix}/bin
  include files           ${prefix}/include
  libraries               ${exec_prefix}/lib
  manual pages            ${datarootdir}/man
  vad packages            ${datarootdir}/virtuoso-opensource-7/vad
  database                /var/lib/virtuoso-opensource-7/db
  hosting                 ${exec_prefix}/lib/virtuoso-opensource-7/hosting

Options
  BUILD_OPTS               xml ssl imsg pldebug shapefileio pthreads