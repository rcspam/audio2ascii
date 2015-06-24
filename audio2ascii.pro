QT       += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = audio2ascii-qt
TEMPLATE = app

SOURCES += qt/main.cpp qt/a2a.cpp qt/sox.cpp
HEADERS  += qt/a2a.h qt/sox.h
FORMS    += qt/a2a.ui
RESOURCES += qt/res.qrc
