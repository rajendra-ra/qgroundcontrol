docker build --file ./deploy/docker/Dockerfile-deploy-linux -t qgc-linux-deploy-docker .
mkdir -p build
docker run --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined --rm -v ${PWD}:/project/source -v ${PWD}/build:/project/build qgc-linux-deploy-docker
