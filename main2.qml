import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: Screen.width
    height: Screen.height
    visibility: Window.FullScreen
    color: "white"

    Loader {
        id: loader
        anchors.fill: parent
        source: "qrc:/Splash.qml"

        Timer {
            interval: 5000
            running: true
            repeat: false
            onTriggered: loader.source = "qrc:/CanPage.qml"
        }
    }
}

