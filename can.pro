TARGET = can
TEMPLATE = app

QT += quick core gui network quickcontrols2
CONFIG += c++17 release

SOURCES += main.cpp \
           canhandler.cpp

HEADERS += canhandler.h

RESOURCES += qml.qrc
