#!/bin/sh

#  build_number.sh
#  TwitterPhotoUploader
#
#  Created by 武田 祐一 on 2015/01/18.
#  Copyright (c) 2015年 Yuichi Takeda. All rights reserved.

GIT_MARKETING_VERSION=`git describe --abbrev=0 --tags`
GIT_BUILD_NUMBER=`git rev-parse --short HEAD`

cat > BuildNumber.h <<EOT
#ifdef DEBUG
#define MARKETING_VERSION ${GIT_MARKETING_VERSION}-dev
#define BUILD_NUMBER ${GIT_BUILD_NUMBER}
#else
#define MARKETING_VERSION ${GIT_MARKETING_VERSION}
#define BUILD_NUMBER ${GIT_BUILD_NUMBER}
#endif
EOT