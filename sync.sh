#!/usr/bin/env bash

#alicr_user_name
#alicr_pass_word
#gh_user_name
#GH_TOKEN

# cname: company name
# uname: user name
# iname: image name
# tname: tag name

count=0
gh_repo="https://${gh_user_name}:${GH_TOKEN}@github.com/${gh_user_name}/mirror.crs2ali.sh.git"

# L3
for cname in `ls ./cr3`
do
  for uname in `ls ./cr3/${cname}`
  do
    for iname in `ls ./cr3/${cname}/${uname}`
    do
      for tname in `ls ./cr3/${cname}/${uname}/${iname}`
      do
        if [ ! -f ./cr3/${cname}/${uname}/${iname}/${tname}/done.md ];then
          docker pull ${cname}/${uname}/${iname}:${tname}
          docker tag ${cname}/${uname}/${iname}:${tname} registry.cn-shanghai.aliyuncs.com/shaneking-sh/${cname}_${uname}_${iname}:${tname}
          docker push registry.cn-shanghai.aliyuncs.com/shaneking-sh/${cname}_${uname}_${iname}:${tname}
          touch done.md
          let count=$count+1
        fi
      done
    done
  done
done

# rname: r name, https://hub.docker.com/r/vmware/registry-photon/

# L4


if [ $count -gt 0 ];then
  git -C . add -A
  git -C . commit -m "sync images at $(date +'%Y-%m-%d %H:%M')"
  echo $gh_repo
  git -C . push -f $gh_repo mirror:mirror
fi
