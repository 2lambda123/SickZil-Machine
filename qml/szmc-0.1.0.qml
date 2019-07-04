// TODO: decompose it. especially, remove magic string & numbers!

import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.4
import QtQuick.Window 2.2


ApplicationWindow {
    id: window
    visible: true
    width: 850; height: 750
    visibility: Window.Maximized

    MessageDialog {
        id: msgDialog
    }
    //-------------------------------------------------------------
    /*
    Connections {
        target: main
        onImageUpdate: {
            console.log('received signal', impath)
            im.source = "image://imp/" + impath
        }
        onWarning: {
            console.log('received warning:', msg)
            msgDialog.title = "project format error"
            msgDialog.text = msg;
            msgDialog.visible = true;
        }
        onImListUpdate: {
            console.log('received 2 list:')
            console.log('--------------')
            console.log('img')

            console.log(imgs[0])
            console.log(imgs[1])
            for(var img in imgs){
                console.log(img)
            }
            console.log('--------------')
            console.log('masks')
            for(var mask in masks){
                console.log(mask)
            }
        }
        onLoadToCanvas: {
            console.log('load', impath)
            var url = "image://mask_provider/" + impath
            canvas.loadImage(url)
            canvas.impath = url // how to unable cacheing?
        }
    }
    */

    //=============================================================
    FileDialog {
        id: projectOpenDialog
        selectFolder: true
        onAccepted: {
            main.open_project(projectOpenDialog.fileUrl)
        }
    }

    Action {
        id: openProject
        text: "Open Manga Project Folder" 
        onTriggered: projectOpenDialog.open()
    }

    menuBar: MenuBar {
        Menu {
            title: "&Open"
            MenuItem { action: openProject }
            MenuItem { 
                text: "Open &Mask" 
            }
        }
    }

    //-------------------------------------------------------------
    readonly property double w_icon:41
    readonly property double h_icon:w_icon

    readonly property double x_one: 3.4
    readonly property double y_one: 2.5
    readonly property double w_one: 35
    readonly property double h_one: 32

    readonly property double x_all: 3.1
    readonly property double y_all: 2.5
    readonly property double w_all: 35
    readonly property double h_all: w_all

    toolBar: ToolBar {
        RowLayout {
            // TODO: Refactor: Add SzmcToolBtn type
            // TODO: add unavailable icon.
            ToolButton {
                Image {
                    source: "../resource/mask_btn.png"
                    x:     x_one; y:      y_one
                    width: w_one; height: h_one
                }
                Layout.preferredHeight: w_icon
                Layout.preferredWidth:  h_icon
                onClicked: { 
                    var img = main.gen_segmap()
                    console.log(img)
                    /*
                    canvas.grabToImage( #TODO: get smap from mask after edit..
                        function(img) {
                            img.saveToFile("test_imgs/test.png")
                            main.get_canvas(img)
                        }
                    )
                    */
                }
            }
            ToolButton {
                Image {
                    source: "../resource/rmtxt_btn.png"
                    x:     x_one; y:      y_one
                    width: w_one; height: h_one
                }
                Layout.preferredHeight: w_icon
                Layout.preferredWidth:  h_icon
                onClicked: {
                    //main.rm_txt()
                }
            }
            ToolButton {
                Image {
                    source: "../resource/mask_all_btn.png"
                    x:     x_all; y:      y_all
                    width: w_all; height: h_all
                }
                Layout.preferredHeight: w_icon
                Layout.preferredWidth:  h_icon
                onClicked: {
                    //main.rm_txt()
                }
            }
            ToolButton {
                Image {
                    source: "../resource/rmtxt_all_btn.png"
                    x:     x_all; y:      y_all
                    width: w_all; height: h_all
                }
                Layout.preferredHeight: w_icon
                Layout.preferredWidth:  h_icon
                onClicked: {
                    //main.rm_txt()
                }
            }
        }
    }

    //-------------------------------------------------------------
    RowLayout {
        anchors.fill: parent
        spacing: 6
        ScrollView {
            objectName: "view"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Image { 
                id: "im"
                objectName: "image"
                source: "image://imp/req.png"
                Canvas {
                    id: canvas
                    anchors.fill: parent

                    property int lastX: 0
                    property int lastY: 0
                    property string impath: ""

                    MouseArea {
                        id: area
                        anchors.fill: parent
                        onPressed: {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                        }

                        onPositionChanged: {
                            canvas.requestPaint();
                        }

                    }
                    onImageLoaded: {
                        console.log('loaded?')
                        var ctx = getContext("2d");
                        //ctx.closePath();
                        ctx.clearRect(0,0, width,height)
                        ctx.drawImage(impath, 0, 0);
                        requestPaint();
                    }
                    onPaint: {
                        console.log('painted?')
                        var ctx = getContext("2d");
                        ctx.lineCap = 'round'
                        ctx.strokeStyle = "#FF0000"
                        ctx.lineWidth = 10;
                        ctx.beginPath();

                        ctx.moveTo(lastX, lastY);

                        lastX = area.mouseX;
                        lastY = area.mouseY;
                        ctx.lineTo(lastX,lastY);
                        ctx.stroke();

                    }
                } 
            }
        }

        ScrollView {
            Layout.fillHeight: true
            Layout.preferredWidth: 400
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            ListView {
                width: 200; height: 200
                //anchors.fill: parent
                model: Model    
                delegate: Item {
                    width: 200
                    height: 20
                    Row {
                        Text {
                            width: 60
                            text: image + "      " + mask
                            //horizontalAlignment: Text.AlignHCenter
                            //anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }
    }
    
    statusBar: StatusBar {
        RowLayout {
            anchors.fill: parent
            Label { text: "Read Only" }
        }
    }

    //=============================================================
}