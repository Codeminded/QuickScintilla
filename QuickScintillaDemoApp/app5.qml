import Scintilla 1.0
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
//import Qt.labs.platform 1.1

ApplicationWindow {
    id: myRoot
    width: 600
    height: 400
    visible: true

    property string urlPrefix: "file://"

    Component.onCompleted: {
    	applicationData.setScintilla(quickScintillaEditor)
	}

    function buildValidUrl(path) {
        // ignore call, if we already have a file:// url
        path = path.toString()
        if( path.startsWith(urlPrefix) )
        {
            return path;
        }
        // ignore call, if we already have a content:// url (android storage framework)
        if( path.startsWith("content://") )
        {
            return path;
        }

        var sAdd = path.startsWith("/") ? "" : "/"
        var sUrl = urlPrefix + sAdd + path
        return sUrl
    }

    function readCurrentDoc(url) {
        // then read new document
        var urlFileName = buildValidUrl(url)
        lblFileName.text = urlFileName
        quickScintillaEditor.text = applicationData.readFileContent(urlFileName)
    }

    Button {
        id: btnLoadFile
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Load file"
        onClicked: {
            //fileDialog.fileMode = FileDialog.OpenFile
            fileDialog.title = "Choose a file"
            fileDialog.selectExisting = true
            fileDialog.openMode = true
            fileDialog.open()
        }
    }

    Button {
        id: btnSaveFile
        //enabled: lblFileName.text.startsWith(urlPrefix)
        anchors.top: parent.top
        anchors.left: btnLoadFile.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Save file as"
        onClicked: {
            //fileDialog.fileMode = FileDialog.SaveFile
            fileDialog.title = "Save a file"
            fileDialog.selectExisting = false
            fileDialog.openMode = false
            fileDialog.open()
        }
    }

    Button {
        id: btnClearText
        anchors.top: parent.top
        anchors.left: btnSaveFile.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Clear"
        onClicked: {
            quickScintillaEditor.text = ""
            lblFileName.text = "unknown.txt"
            //for Tests only: Qt.inputMethod.show()
            scrollView.focus = true
            //quickScintillaEditor.focus = true
        }
    }

    Button {
        id: btnShowText
        anchors.top: parent.top
        anchors.left: btnClearText.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Show text"
        onClicked: {
            infoDialog.text = quickScintillaEditor.text
            //for Tests only: infoDialog.text = " "+scrollView.contentItem
            infoDialog.open()
            //for Tests only: readCurrentDoc("/sdcard/Texte/mgv_quick_qdebug.log")
            /*for Tests only: */quickScintillaEditor.text = applicationData.readLog()
        }
    }

    Text {
        id: lblFileName
        anchors.top: btnLoadFile.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        //anchors.verticalCenter: btnShowText.verticalCenter
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        text: "?"
    }

    FileDialog {
        id: fileDialog
        visible: false
        modality: Qt.WindowModal
        title: "Choose a file"
        folder: "."

        property bool openMode: true

        selectExisting: true
        selectMultiple: false
        selectFolder: false

        onAccepted: {
            console.log("Accepted: " + /*currentFile*/fileUrl+" "+fileDialog.openMode)
            /*if(fileDialog.fileMode === FileDialog.SaveFile)*/if(!fileDialog.openMode) {
                var ok = applicationData.writeFileContent(/*currentFile*/fileUrl, quickScintillaEditor.text)
            }
            else {
                readCurrentDoc(/*currentFile*/fileUrl)
            }
            scrollView.focus = true
        }
        onRejected: {
            console.log("Rejected")
            scrollView.focus = true
        }
    }

    MessageDialog {
        id: infoDialog
        visible: false
        title: qsTr("Info")
        standardButtons: StandardButton.Ok
        onAccepted: {
            console.log("Close info dialog")
            scrollView.focus = true
            //quickScintillaEditor.focus = true
        }
    }

    function max(v1, v2) {
        return v1 < v2 ? v2 : v1;
    }

//    ScintillaEditBase {
//        id: quickScintillaEditor

//        anchors.top: lblFileName.bottom
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        anchors.left: parent.left
//        anchors.rightMargin: 5
//        anchors.leftMargin: 5
//        anchors.topMargin: 5
//        anchors.bottomMargin: 5

//        // position of the QuickScintilla controll will be changed in response of signals from the ScrollView
//        x : 0
//        y : 0

//        Accessible.role: Accessible.EditableText

//        //implicitWidth: 1600//1000
//        //implicitHeight: 1800//3000
//        font.family: "Courier New"  //*/ "Hack"
//        font.pointSize: 18
//        focus: true
//        text: "Welcome scintilla in the Qt QML/Quick world !\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10\nLine 11\nLine 12\nLine 13\nLine 14\nLine 15\nLine 16\nLine 17\nlast line is here!\n"+parent.x+ " "+parent.y+" "+x+" "+y
//    }

    // Use Scrollview to handle ScrollBars for QuickScintilla control.
    // Scrollbar uses Rectangle as flickable item which has the implicitSize of the QuickScintilla control
    // (implicitSize is the maximun size needed to show the full content of the QuickScintilla control).
    // The QuickScintilla controll will be placed at the currently visible viewport of the ScrollView.
    //Flickable {
    ScrollView {
        id: scrollView
        focus: true
        clip: true
        //focusPolicy: Qt.StrongFocus
        //filtersChildMouseEvents: false


        property alias quickScintillaEditor: quickScintillaEditor
        //property Flickable flickableItem: flickableItem
        //property alias vScrollBar: ScrollBar.vertical
        property bool actionFromKeyboard: false

        //anchors.fill: parent
        //anchors.centerIn: parent
        anchors.top: lblFileName.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        // box needed to support ScrollView and simulate current maximum size of scintilla text control
        // editor control will be placed in visible part of this rectangle
        Rectangle {
            id: editorFrame

            anchors.fill: parent

//            // TODO dies macht die Probleme mit den verschwindenden Moue Events !!! width/height ok, logicalWidth/logicalHeight oder width+1/height nicht ok ?
            implicitWidth: quickScintillaEditor.logicalWidth //quickScintillaEditor.width+200 //500 //quickScintillaEditor.logicalWidth
            implicitHeight: quickScintillaEditor.logicalHeight //quickScintillaEditor.height+500 //800 //quickScintillaEditor.logicalHeight

//            //color: "lightgrey"

            // the QuickScintilla control
            //TextEdit {
            ScintillaEditBase {
                id: quickScintillaEditor

                // for TextTedit tests
         //       mouseSelectionMode: TextEdit.SelectCharacters
         //       selectByMouse: true

                width: scrollView.availableWidth //+ 2*quickScintillaEditor.charHeight
                height: scrollView.availableHeight //+ 2*quickScintillaEditor.charWidth

                // position of the QuickScintilla controll will be changed in response of signals from the ScrollView
                x : 0
                y : 0

                Accessible.role: Accessible.EditableText

//                implicitWidth: quickScintillaEditor.logicalWidth // 1600//1000
//                implicitHeight: quickScintillaEditor.logicalHeight //1800//3000
                font.family: "Courier New"  //*/ "Hack"
                font.pointSize: 18
                focus: true
                text: "Welcome scintilla in the Qt QML/Quick world !\nLine 2 for while if else blub done\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10\nLine 11\nLine 12\nLine 13\nLine 14\nLine 15\nLine 16\nLine 17\nlast line is here!\n"+parent.x+ " "+parent.y+" "+x+" "+y
/*
                MouseArea {
                    id: mouseArea
                    z: -1

                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton
                    propagateComposedEvents: true

                    onClicked: {
                        console.log("CLICK mouseArea")
                        mouse.accepted = false
                    }
                    onPressAndHold: {
                        console.log("CLICKAndHold mouseArea")
                        mouse.accepted = false
                    }
                    onPositionChanged: {
                        console.log("position changed")
                    }
                }
*/
            }
        }

        Menu {
            id: editMenu

            MenuItem {
                text: "Copy"
                onTriggered: {
                    console.log("Copy! "+quickScintillaEditor.visibleColumns)
                }
            }
            MenuItem {
                text: "Cut"
                onTriggered: {
                    console.log("Cut!")
                }
            }
            MenuItem {
                text: "Paste"
                onTriggered: {
                    console.log("Paste!")
                }
            }
        }

        Connections {
            // https://stackoverflow.com/questions/30359262/how-to-scroll-qml-scrollview-to-center
            target: scrollView.contentItem //.flickableItem //.ScrollBar.vertial

            onContentXChanged: {
                var delta = scrollView.contentItem.contentX - quickScintillaEditor.x
                var deltaInColumns = parseInt(delta / quickScintillaEditor.charWidth,10)
                //console.log("xchanged delta="+delta+" deltaCol="+deltaInColumns+" shift="+deltaInColumns*quickScintillaEditor.charWidth+" contentX="+scrollView.contentItem.contentX+" scintillaX="+quickScintillaEditor.x)
                if(delta >= quickScintillaEditor.charWidth) {
                    //console.log("p1")
                    if(!scrollView.actionFromKeyboard)
                    {
                        // disable repaint: https://stackoverflow.com/questions/46095768/how-to-disable-update-on-a-qquickitem
                        quickScintillaEditor.enableUpdate(false);
                        quickScintillaEditor.x = quickScintillaEditor.x // + deltaInColumns*quickScintillaEditor.charWidth    // TODO --> bewirkt geometry changed !!!
                        quickScintillaEditor.scrollColumn(deltaInColumns)
                        quickScintillaEditor.enableUpdate(true)
                    }
                }
                else if(-delta >= quickScintillaEditor.charWidth) {
                    //console.log("p2")
                    if(!scrollView.actionFromKeyboard)
                    {
                        quickScintillaEditor.enableUpdate(false);
                        quickScintillaEditor.x = quickScintillaEditor.x + deltaInColumns*quickScintillaEditor.charWidth      // deltaInColumns is < 0
                        if(quickScintillaEditor.x < 0)
                        {
                            quickScintillaEditor.x = 0
                        }
                        quickScintillaEditor.scrollColumn(deltaInColumns)   // deltaInColumns is < 0
                        quickScintillaEditor.enableUpdate(true)
                    }
                }
                else {
                    //console.log("p3")
                }
            }
            onContentYChanged: {
                //console.log("YCHANGED")
                var delta = scrollView.contentItem.contentY - quickScintillaEditor.y
                var deltaInLines = parseInt(delta / quickScintillaEditor.charHeight,10)
                if(delta >= quickScintillaEditor.charHeight) {
                    //console.log("P1")
                    // disable repaint: https://stackoverflow.com/questions/46095768/how-to-disable-update-on-a-qquickitem
                    quickScintillaEditor.enableUpdate(false);
                    quickScintillaEditor.y = quickScintillaEditor.y + deltaInLines*quickScintillaEditor.charHeight    // TODO --> bewirkt geometry changed !!!
                    quickScintillaEditor.scrollRow(deltaInLines)
                    quickScintillaEditor.enableUpdate(true)
                }
                else if(-delta >= quickScintillaEditor.charHeight) {
                    //console.log("P2")
                    quickScintillaEditor.enableUpdate(false);
                    quickScintillaEditor.y = quickScintillaEditor.y + deltaInLines*quickScintillaEditor.charHeight
                    if(quickScintillaEditor.y < 0)
                    {
                        quickScintillaEditor.y = 0
                    }
                    quickScintillaEditor.scrollRow(deltaInLines) // -1 * -1
                    quickScintillaEditor.enableUpdate(true)
                }
                else {
                    //console.log("P3")
                }
            }
        }

/*
        Connections {
            target: editorFrame

            onMouseMoved: {
                console.log("Mouse Move")
            }
        }
*/
        // process signals from the quick scintilla editor control triggered by keyboard interactions
        Connections {
            target: quickScintillaEditor

            onShowContextMenu: {
                console.log("CONTEXT MENU")
                //editMenu.open()
                editMenu.popup(pos)
            }

            onDoubleClick: {
                console.log("double click !")
            }

/*
            onMarginClicked: {
                console.log("MARGING CLICK !")
            }

            onTextAreaClicked: {
                console.log("TextArea CLICK !")
            }
*/
            // this signal is emited if the scintilla editor contol scrolls, because of a keyboard interaction
            //   --> update the scrollview appropriate: move editor control to right position and
            //       update content area and position of scroll view (results in updating the scrollbar)
            onHorizontalScrolled: {
                // value from scintilla in pixel !
                //var v = value/quickScintillaEditor.logicalWidth // /quickScintillaEditor.charWidth/quickScintillaEditor.totalColumns
                //console.log("HSCROLL "+value+" new="+v+" firstVisibleCol="+quickScintillaEditor.firstVisibleColumn+" charWidth="+quickScintillaEditor.charWidth+" editor.x="+quickScintillaEditor.x+" logicalWidth="+quickScintillaEditor.logicalWidth)
            //    scrollView.actionFromKeyboard = true
                //bad: scrollView.ScrollBar.horizontal.position = v      // TODO: recursive call crash !
                quickScintillaEditor.x = value              // order of calls is very important: first update child and then the container !
                scrollView.contentItem.contentX = value
            //    scrollView.actionFromKeyboard = false
            }
            onVerticalScrolled: {
                // value from scintilla in lines !
                //var v = value/quickScintillaEditor.totalLines
                //console.log("VSCROLL "+value+" total_lines="+quickScintillaEditor.totalLines+" char_height="+quickScintillaEditor.charHeight+" new="+v)
                //bad: scrollView.ScrollBar.vertical.position = v
                quickScintillaEditor.y = value //*quickScintillaEditor.charHeight           // Bugfix 13.8.2022, because of change in ScintillaEditBase.cpp in line #598: use QPoint instead of point
                scrollView.contentItem.contentY = value //*quickScintillaEditor.charHeight
            }
            onHorizontalRangeChanged: {
                //console.log("HRANGE max="+max+" page="+page+" totalCol="+quickScintillaEditor.totalColumns+" visibleCol="+quickScintillaEditor.visibleColumns+" firstVisibleCol="+quickScintillaEditor.firstVisibleColumn)
                //not needed: scrollView.ScrollBar.horizontal.size = page/quickScintillaEditor.totalColumns
            }
            onVerticalRangeChanged: {
                //console.log("VRANGE max="+max+" page="+page+" totalLines="+quickScintillaEditor.totalLines+" visibleLines="+quickScintillaEditor.visibleLines)
                //not needed: scrollView.ScrollBar.vertical.size = page/quickScintillaEditor.totalLines
            }
        }

        /* For tests with Flickable:

        SimpleScrollBar {
            id: verticalScrollBar
            width: 12
            visible: true
            height: scrollView.height-12
            anchors.right: parent.right
            opacity: 1
            orientation: Qt.Vertical
            position: quickScintillaEditor.firstVisibleLine/quickScintillaEditor.totalLines
            pageSize: quickScintillaEditor.height/max(quickScintillaEditor.logicalHeight,quickScintillaEditor.height) // 0.5 //view.visibleArea.heightRatio
        }

        SimpleScrollBar {
            id: horizontalScrollBar
            width: scrollView.width-12
            height: 12//+50
            //scrollView.height
            visible: true
            //anchors.bottom: parent.bottom+50
            y: scrollView.height-12 //-50
            opacity: 1
            orientation: Qt.Horizontal
            position: quickScintillaEditor.firstVisibleColumn/quickScintillaEditor.totalColumns
            pageSize: quickScintillaEditor.width/max(quickScintillaEditor.logicalWidth,quickScintillaEditor.width) //0.25 //quickScintillaEditor.widthRatio
        }
        */
   }

}
