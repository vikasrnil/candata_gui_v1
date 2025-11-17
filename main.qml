import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: Screen.width
    height: Screen.height
    visibility: Window.FullScreen
    color: "white"

    Rectangle {
    anchors.fill: parent
    color: "#0b1d0f"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Text {
            text: "🚜 Escorts Kubota CAN Monitor"
            font.pixelSize: 36
            font.bold: true
            color: "#ffcc00"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            width: parent.width
            height: 50
            radius: 8
            color: "#1f2f1f"
            border.color: "#ffcc00"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 30

                Text { text: "CAN ID"; font.pixelSize: 20; color: "#ffffff"; Layout.preferredWidth: 100 }
                Text { text: "Data"; font.pixelSize: 20; color: "#ffffff"; Layout.preferredWidth: 200 }
                Text { text: "Cycle Time"; font.pixelSize: 20; color: "#ffffff"; Layout.preferredWidth: 100 }
                Text { text: "Comment"; font.pixelSize: 20; color: "#ffffff"; Layout.fillWidth: true }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: canList
                model: canModel
                delegate: Rectangle {
                    width: canList.width
                    height: 50
                    radius: 6
                    color: index % 2 === 0 ? "#143314" : "#1f2f1f"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 30

                        Text {
                            text: canId
                            font.pixelSize: 18
                            color: "#ffffff"
                            Layout.preferredWidth: 100
                        }

                        Text {
                            text: canData !== "" ? canData : "--"
                            font.pixelSize: 18
                            color: "#ffffff"
                            elide: Text.ElideRight
                            Layout.preferredWidth: 200
                        }

                        Text {
                            text: cycleTime !== "" ? cycleTime : "--"
                            font.pixelSize: 18
                            color: "#00ff00"
                            Layout.preferredWidth: 100
                        }

                        TextField {
                            text: comment
                            placeholderText: "Add comment"
                            font.pixelSize: 16
                            color: "#ffffff"
                            background: Rectangle {
                                color: "#2a2a2a"
                                radius: 4
                            }
                            Layout.fillWidth: true
                            onTextChanged: {
                                canModel.set(index, {
                                    canId: canId,
                                    canData: canData,
                                    cycleTime: cycleTime,
                                    comment: text
                                })
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            visible: canModel.count === 0
            width: parent.width
            height: 100
            color: "transparent"
            Text {
                anchors.centerIn: parent
                text: "No CAN Data Detected"
                color: "#888888"
                font.pixelSize: 26
            }
        }
    }

    ListModel { id: canModel }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: updateCanData()
    }
}


    function updateCanData() {
        let keys = Object.keys(canHandler.canMap)
        for (let i = 0; i < keys.length; i++) {
            let id = keys[i]
            let raw = canHandler.canMap[id]
            if (!raw || typeof raw !== "string") continue

            let canData = "--"
            let cycleTime = "--"

            let openParen = raw.indexOf("(")
            let closeParen = raw.indexOf(")")

            if (openParen > 0 && closeParen > openParen) {
                canData = raw.substring(0, openParen).trim()
                cycleTime = raw.substring(openParen + 1, closeParen).trim()
            } else {
                canData = raw.trim()
            }

            let found = false
            for (let j = 0; j < canModel.count; j++) {
                if (canModel.get(j).canId === id) {
                    let existingComment = canModel.get(j).comment
                    canModel.set(j, {
                        canId: id,
                        canData: canData,
                        cycleTime: cycleTime,
                        comment: existingComment
                    })
                    found = true
                    break
                }
            }
            if (!found) {
                canModel.append({
                    canId: id,
                    canData: canData,
                    cycleTime: cycleTime,
                    comment: ""
                })
            }
        }

        for (let j = canModel.count - 1; j >= 0; j--) {
            let id = canModel.get(j).canId
            if (!canHandler.canMap.hasOwnProperty(id)) {
                canModel.remove(j)
            }
        }
    }


}










