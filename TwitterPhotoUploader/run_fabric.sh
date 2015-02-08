#!/bin/sh

#  run_fabric.sh
#  TwitterPhotoUploader
#
#  Created by 武田 祐一 on 2015/02/08.
#  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.

set -e
SECRET_FILE="fabric_build_secret.txt"

if [ ! -f $SECRET_FILE ]; then
    echo "warning: fabric build secret file does not exists."
else
    read FABRIC_BUILD_SECRET < $SECRET_FILE
    ./Fabric.framework/run cba389e5068a247f311d2eeacd85a60d17a5c880 $FABRIC_BUILD_SECRET
fi
