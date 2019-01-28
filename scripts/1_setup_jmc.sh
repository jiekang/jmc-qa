#!/bin/bash
source $(dirname "$0")/config.sh

# if a jmc folder already exists, remove it prior to cloning
if [ -d $JMC_ROOT ]; then
    rm -r $JMC_ROOT;
fi

# clone the jmc repo
hg clone $JMC_REPO $JMC_ROOT || { exit 1; };

# import proposed patch for jmc-6370
cd $JMC_ROOT
hg import --no-commit ../patches/jmc-6370.diff
cd ../

# setup the p2 repository
mvn p2:site -f $JMC_THIRD_PARTY/pom.xml || { exit 1; };

# run the jetty server in the background
mvn jetty:run -f $JMC_THIRD_PARTY/pom.xml &
jetty_pid=$!;

# build jmc-core
mvn clean install --quiet -f $JMC_CORE/pom.xml || { exit 1; };

# build jmc
mvn package --quiet -f $JMC_ROOT/pom.xml || { exit 1; };

# kill the jetty process
kill $jetty_pid;
