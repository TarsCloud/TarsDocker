
WORKDIR=$(cd $(dirname $0); pwd)

cd ../tars-chart

helm package tars-stable
mv tars-stable*.tgz ../charts/stable
helm repo index ../charts/stable --url https://tarscloud.github.io/TarsDocker/charts/stable

helm package tars-dev
mv tars-dev*.tgz ../charts/dev
helm repo index ../charts/dev --url https://tarscloud.github.io/TarsDocker/charts/dev


