#/bin/bash
# -------------------------------------------------- #
# collects deploy info
# -------------------------------------------------- #
# environment
# -------------------------------------------------- #
PATH=$PATH:/usr/local/bin
. /usr/local/lib/rvm
rvm use 2.1.1
# -------------------------------------------------- #
# initialization
# -------------------------------------------------- #
APP=gup-publications
DEPDIR=/data/rails/gup-publications
INFOFILE=deploy-info.html
DEPLOYER=$1
SEPARATOR='# ---------------------------------------- #'
HTMLHEADER='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>gup-publications</title>
</head>
<body>
<h3>'${APP}'</h3>
<pre>
'
HTMLFOOTER='
</pre>
</body>'
# -------------------------------------------------- #
# deploy
# -------------------------------------------------- #
cd $DEPDIR
git pull
bundle install
rake db:migrate RAILS_ENV=production
touch tmp/restart.txt
# -------------------------------------------------- #
# create deploy-info.html available in web root
# -------------------------------------------------- #
echo ${HTMLHEADER}                                        > $INFOFILE
echo $SEPARATOR                                          >> $INFOFILE
date                                                     >> $INFOFILE
echo "DEPLOYER:$DEPLOYER"                                >> $INFOFILE
echo $SEPARATOR                                          >> $INFOFILE
git show HEAD | head -5 | awk '{gsub("<[^>]*>", "")}1'   >> $INFOFILE
echo $SEPARATOR                                          >> $INFOFILE
echo ${HTMLFOOTER}                                       >> $INFOFILE
chmod 664 ${INFOFILE}
mv ${INFOFILE} public
