# nvm use 4.0 # already done in CI
node --version
npm --version
npm install -g elm

cd ./test && npm install
cd ./test && elm package install -y
cd ./examples/basic && elm package install -y
cd ./examples/full && elm package install -y
