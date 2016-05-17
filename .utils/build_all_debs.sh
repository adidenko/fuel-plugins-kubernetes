#!/bin/bash

CWD=$(cd `dirname $0` && pwd -P)

TMPDIR=/tmp/fuel-plugin-kubernetes-debs
mkdir -p $TMPDIR

etcd_ver='2.3.3'
flannel_ver='0.5.5'
kubernetes_ver='1.2.4'

pushd $TMPDIR
rm -rf etcd flannel kubernetes
wget -c -N https://github.com/coreos/etcd/releases/download/v${etcd_ver}/etcd-v${etcd_ver}-linux-amd64.tar.gz
tar xzf etcd-v${etcd_ver}-linux-amd64.tar.gz
mv etcd-v${etcd_ver}-linux-amd64 etcd
wget -c -N https://github.com/coreos/flannel/releases/download/v${flannel_ver}/flannel-${flannel_ver}-linux-amd64.tar.gz
tar xzf flannel-${flannel_ver}-linux-amd64.tar.gz
mv flannel-${flannel_ver} flannel
wget -c -N  https://github.com/kubernetes/kubernetes/releases/download/v${kubernetes_ver}/kubernetes.tar.gz
tar xzf kubernetes.tar.gz kubernetes/server/kubernetes-server-linux-amd64.tar.gz
tar xzf kubernetes/server/kubernetes-server-linux-amd64.tar.gz
popd

$CWD/build_static_deb.sh etcd $etcd_ver $TMPDIR/etcd
$CWD/build_static_deb.sh flannel $flannel_ver $TMPDIR/flannel/flanneld
for file in `find $TMPDIR/kubernetes/server -type f -executable`; do
  fname=${file##*/}
  $CWD/build_static_deb.sh $fname $kubernetes_ver $file
done

#$CWD/build_static_deb.sh etcd $etcd_ver $CWD/../.binaries/etcd/v$etcd_ver
#$CWD/build_static_deb.sh flannel $flannel_ver $CWD/../.binaries/flannel/v$flannel_ver
#for file in `find $CWD/../.binaries/kubernetes/v$kubernetes_ver -type f -executable`; do
#  fname=${file##*/}
#  $CWD/build_static_deb.sh $fname $kubernetes_ver $file
#done
