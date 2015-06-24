QT       += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = audio2ascii-qt
VERSION = 1.0beta1
TEMPLATE = app

SOURCES += qt/main.cpp qt/a2a.cpp qt/sox.cpp
HEADERS  += qt/a2a.h qt/sox.h
FORMS    += qt/a2a.ui
RESOURCES += qt/res.qrc
OTHER_FILES += audio2ascii.spec

QMAKE_TARGET_DESCRIPTION="Audio Curve Generator"
QMAKE_TARGET_COPYRIGHT="Copyright 2015 @rcspam and @olear"
QMAKE_TARGET_PRODUCT="audio2ascii"

QMAKE_CLEAN += Makefile target
DEFINES += A2A_VERSION=\"\\\"$${VERSION}\\\"\"

lessThan(QT_MAJOR_VERSION, 5): win32:RC_FILE += audio2ascii.rc
greaterThan(QT_MAJOR_VERSION, 4):win32:RC_ICONS += qt/gfx/audio2ascii.ico

DESTDIR = build
OBJECTS_DIR = $$DESTDIR/tmp
MOC_DIR = $$DESTDIR/tmp
RCC_DIR = $$DESTDIR/tmp
UI_DIR = $$DESTDIR/tmp

unix {
    isEmpty(PREFIX) {
        PREFIX = /usr/local
    }
    isEmpty(DOCDIR) {
        DOCDIR = $${PREFIX}/share/doc
    }
    target.path = $${PREFIX}/bin
    target_icon.path = $${PREFIX}/share/pixmaps
    target_icon.files = qt/gfx/audio2ascii.png
    target_desktop.path = $${PREFIX}/share/applications
    target_desktop.files = audio2ascii-qt.desktop audio2ascii-yad.desktop
    target_docs.path = $${DOCDIR}/audio2ascii-$${VERSION}
    target_docs.files = README.md LICENSE
    target_script.path = $${PREFIX}/bin
    target_script.files = audio2ascii.sh
    INSTALLS += target target_icon target_desktop target_docs target_script
}
