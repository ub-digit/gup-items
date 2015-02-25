TESTSERVER=130.241.16.49                    # rails-test.ub.gu.se
DRIFTSERVER=130.241.35.161                  # rails.ub.gu.se
DEPHOST=`hostname --all-ip-addresses`
DESTDIR=/data/rails/gup-publications
INFOSCRIPT=${DESTDIR}/create-deploy-info.sh 
APPENV=production

all:
	@echo -n "run like this:"
	@echo    "'make deploy-test'"
	@echo -n "           or:" 
	@echo    "'make deploy-drift'"

deploy-test: 
	ssh rails@${TESTSERVER} ${INFOSCRIPT} ${USER}:${DEPHOST}

deploy-drift: 
	ssh rails@${DRIFTSERVER} ${INFOSCRIPT} ${USER}:${DEPHOST}




