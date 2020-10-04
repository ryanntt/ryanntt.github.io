set -e

DEPLOY_REPO="https://${MY_PERSONAL_WEBSITE}@github.com/ryanntt/ryanntt.github.io.git"

function main {
	clean
	get_current_site
	build_site
	deploy
}

function clean { 
	echo "cleaning _site folder"
	if [ -d "_site" ]; then rm -Rf _site; fi 
}

function get_current_site { 
	echo "getting latest site"
	git clone --depth 1 $DEPLOY_REPO _site 
}

function build_site { 
	echo "building site"
	JEKYLL_ENV=production bundle exec jekyll build --trace
}

function deploy {
	echo "deploying changes"

	if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
	    echo "except don't publish site for pull requests"
	    exit 0
	fi  

	if [ "$TRAVIS_BRANCH" != "build" ]; then
	    echo "except we should only publish the build branch. stopping here"
	    exit 0
	fi

	cd _site
	git config --global user.name "Ryan Nguyen"
    git config --global user.email ryannguyentt@gmail.com
	git add -A
	git status
	git commit -m "Lastest site built on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to github"
	git push $DEPLOY_REPO master:master
}

main