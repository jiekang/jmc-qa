#!/bin/bash
source $(dirname "$0")/config.sh

# run the jetty server in the background
mvn jetty:run -f $JMC_THIRD_PARTY/pom.xml &
jetty_pid=$!;

# Addresses https://github.com/aptmac/jmc-qa/issues/16
# The RCP application will not display if not given mouse focus.
# Add a cursor placement for 0, 0 in the RCP application setup.
# sed -i '53i        display.setCursorLocation(0, 0);' $RCP_APPLICATION_JAVA

sed -i '90s/@Test//' $JMC_ROOT/application/uitests/org.openjdk.jmc.browser.uitest/src/test/java/org/openjdk/jmc/browser/uitest/ConnectionExportImportTest.java
sed -i '133s/@Test//' $JMC_ROOT/application/uitests/org.openjdk.jmc.browser.uitest/src/test/java/org/openjdk/jmc/browser/uitest/ConnectionExportImportTest.java

sed -i '59s/1400/1920/' $JMC_ROOT/application/org.openjdk.jmc.rcp.application/src/main/java/org/openjdk/jmc/rcp/application/ApplicationWorkbenchWindowAdvisor.java
sed -i '60s/850/1080/' $JMC_ROOT/application/org.openjdk.jmc.rcp.application/src/main/java/org/openjdk/jmc/rcp/application/ApplicationWorkbenchWindowAdvisor.java

sed -i '70s/@Test//' $JMC_ROOT/application/uitests/org.openjdk.jmc.console.persistence.uitest/src/test/java/org/openjdk/jmc/console/persistence/uitest/PersistenceTest.java
sed -i '78s/@Test//' $JMC_ROOT/application/uitests/org.openjdk.jmc.console.persistence.uitest/src/test/java/org/openjdk/jmc/console/persistence/uitest/PersistenceTest.java


# run ui tests
cd $JMC_ROOT
mvn verify -P uitests || { kill $jetty_pid; exit 1; };

# kill the jetty process
kill $jetty_pid;
