
WORKDIR=$(cd $(dirname $0); pwd)

cd ${WORKDIR}
cd ../tars-chart

cd stable
helm package tars
mv tars*.tgz ../../charts/stable
helm repo index ../../charts/stable --url https://tarscloud.github.io/TarsDocker/charts/stable

cd ../dev
helm package tars
mv tars*.tgz ../../charts/dev
helm repo index ../../charts/dev --url https://tarscloud.github.io/TarsDocker/charts/dev


