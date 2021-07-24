#!/bin/bash

# Webcamoid, webcam capture application.
# Copyright (C) 2017  Gonzalo Exequiel Pedone
#
# Webcamoid is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Webcamoid is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
#
# Web-Site: http://webcamoid.github.io/

COMPILER_C=${TARGET_ARCH}-w64-mingw32-${COMPILER_C}
COMPILER_CXX=${TARGET_ARCH}-w64-mingw32-${COMPILER_CXX}

if [ -z "${DISABLE_CCACHE}" ]; then
    EXTRA_PARAMS="-DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_OBJCXX_COMPILER_LAUNCHER=ccache"
fi

export PKG_CONFIG=${TARGET_ARCH}-w64-mingw32-pkg-config
QMAKE_CMD=/usr/${TARGET_ARCH}-w64-mingw32/lib/qt/bin/qmake
LRELEASE_TOOL=/usr/${TARGET_ARCH}-w64-mingw32/lib/qt/bin/lrelease
LUPDATE_TOOL=/usr/${TARGET_ARCH}-w64-mingw32/lib/qt/bin/lupdate

INSTALL_PREFIX=${PWD}/webcamoid-data-${TARGET_ARCH}
buildDir=build-${TARGET_ARCH}
mkdir ${buildDir}
${TARGET_ARCH}-w64-mingw32-cmake \
    -S . \
    -B ${buildDir} \
    -DQT_QMAKE_EXECUTABLE=${QMAKE_CMD} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
    -DCMAKE_C_COMPILER="${COMPILER_C}" \
    -DCMAKE_CXX_COMPILER="${COMPILER_CXX}" \
    -DLRELEASE_TOOL=${LRELEASE_TOOL} \
    -DLUPDATE_TOOL=${LUPDATE_TOOL} \
    ${EXTRA_PARAMS} \
    -DDAILY_BUILD=${DAILY_BUILD}
${TARGET_ARCH}-w64-mingw32-cmake -LA -S . -B ${buildDir}
make -C ${buildDir} -j${NJOBS}
make -C ${buildDir} DESTDIR="${INSTALL_PREFIX}" install
