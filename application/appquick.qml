import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import "component"
import "affectors"
import "loading/loading.js" as Loading 

Rectangle{
    id: mainwindow

    property bool isfullscreen: false
    property var loadingcircles

    signal minClicked()
    signal fullscreen()
    signal maxClicked()
    signal closeClicked()

    width: Screen.desktopAvailableWidth * 0.8
    height:Screen.desktopAvailableHeight * 0.8
    gradient: Gradient {
        GradientStop {id: start; position: 0.0; color: skinbar.startcolor }
        GradientStop {id: middle; position: 0.5; color: skinbar.middlecolor }
        GradientStop {id: stop; position: 1.0; color: skinbar.stopcolor }
    }

    TitleBar{
        id: titlebar
        title: mainconfig.title
        height: 25
        anchors.margins: 0
        isfullscreen: mainwindow.isfullscreen
        skinIsVisible: false

        skinIcon: "../images/icons/dark/appbar.clothes.shirt.png"
        skinHoverIcon: "../images/icons/light/appbar.clothes.shirt.png"
        dropdownmenuIcon: "../images/icons/dark/appbar.control.down.png"
        dropdownmenuHoverIcon: "../images/icons/light/appbar.control.down.png"
        minIcon: "../images/icons/dark/appbar.minus.png"
        minHoverIcon: "../images/icons/light/appbar.minus.png"
        maxIcon: "../images/icons/dark/appbar.fullscreen.box.png"
        maxHoverIcon: "../images/icons/light/appbar.fullscreen.box.png"
        normalIcon: "../images/icons/dark/appbar.app.png"
        normalHoverIcon: "../images/icons/light/appbar.app.png"
        closeIcon: "../images/icons/dark/appbar.close.png"
        closeHoverIcon: "../images/icons/light/appbar.close.png"

        onMinClicked:{
            mainwindow.minClicked()
        }

        onMaxClicked:{
            mainwindow.isfullscreen = !mainwindow.isfullscreen;
            mainwindow.maxClicked();
            skinbar.animationEnabled = false
            skinbar.x = parent.width
        }

        onCloseClicked:{
            Qt.quit();
        }

        onDoubleClicked:{
            titlebar.maxClicked();
        }

        onSkinHovered:{
            skinbar.animationEnabled = true
            if(skinbar.x == parent.width){
                skinbar.opacity = 1
                skinbar.x = parent.width - skinbar.width
            }else{
                skinbar.x = parent.width
                skinbar.opacity = 0
            }
        }
    }

    HorizontalSeparator{
        id: horizontalseparator
        height: 0
        color: "transparent"
        anchors.top: titlebar.bottom
    }

    SkinBar{
        id: skinbar
        parentWidth: parent.width
        width: titlebar.height * 12
        height: titlebar.height
        anchors.top: titlebar.bottom
        startcolor: "green"
        middlecolor: "yellow"
        stopcolor: "white"
        animationEnabled: false
        opacity:0
        z: 100
    }
    

    CenterWindow{
        id: centerwindow
        width: parent.width
        anchors.left: parent.left
        anchors.top: horizontalseparator.bottom
        anchors.right: parent.right
        anchors.bottom: statusbar.top
        gradient: Gradient {
            GradientStop { position: 0.0; color: skinbar.startcolor }
            GradientStop { position: 0.5; color: skinbar.middlecolor }
            GradientStop { position: 1.0; color: skinbar.stopcolor }
        }

        SideBar{
            id: leftsidebar
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            opacity: 1

            gradient: Gradient {
                GradientStop { position: 0.0; color: skinbar.stopcolor }
                GradientStop { position: 0.5; color: skinbar.middlecolor }
                GradientStop { position: 1.0; color: skinbar.startcolor }
            }

            NumberAnimation on width { to: 200; duration: 1000}

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: false
                propagateComposedEvents: true
                onEntered: {}
                onExited: {}
                onWheel: {}
                onClicked: {
                    console.log('leftsidebar');
                    mouse.accepted = false
                }
            }
        }

        SideBar{
            id: rightsidebar
            function stateshow(state){
                rightsidebar.state = rightsidebar.state == "primaryAnchors"? state: "primaryAnchors"
            }

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftsidebar.right
            anchors.right: parent.right
            gradient: Gradient {
                GradientStop { position: 0.0; color: skinbar.stopcolor }
                GradientStop { position: 0.5; color: skinbar.middlecolor }
                GradientStop { position: 1.0; color: skinbar.startcolor }
            }
            state: "primary"

            MouseArea {
                anchors.fill: parent
                // cursorShape: Qt.PointingHandCursor
                hoverEnabled: false
                propagateComposedEvents: true
                onEntered: {}
                onExited: {}
                onWheel: {}
                onClicked: {
                    console.log('rightsidebar');
                    mouse.accepted = false
                }
            }

            states: [
                State {
                    name: "primary"
                    AnchorChanges { 
                        target: rightsidebar
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: leftsidebar.right
                        anchors.right: parent.right
                    }
                },
                State {
                    name: "right"
                    AnchorChanges { target: rightsidebar; anchors.left: parent.right }
                },
                State {
                    name: "left"
                    AnchorChanges { target: rightsidebar; anchors.right: leftsidebar.right }
                },
                State {
                    name: "top"
                    AnchorChanges { target: rightsidebar; anchors.bottom: parent.top }
                },
                State {
                    name: "bottom"
                    AnchorChanges { target: rightsidebar; anchors.top: parent.bottom }
                },
                State {
                    name: "topleft"
                    AnchorChanges { target: rightsidebar; anchors.bottom: parent.top; anchors.right: leftsidebar.right }
                },
                State {
                    name: "topright"
                    AnchorChanges { target: rightsidebar; anchors.bottom: parent.top; anchors.left: parent.right }
                },
                State {
                    name: "bottomleft"
                    AnchorChanges { target: rightsidebar; anchors.top: parent.bottom; anchors.right: leftsidebar.right}
                },
                State {
                    name: "bottomright"
                    AnchorChanges { target: rightsidebar; anchors.top: parent.bottom; anchors.left: parent.right}
                }
            ]

            transitions: [
                Transition {
                    AnchorAnimation { duration: 1000 }
                }
            ]
        }

        MouseArea {
            id: centerwindowmouseArea
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            onPositionChanged: {
                if(mouse.x < 200){
                    leftsidebar.opacity = 1;
                }else{
                    leftsidebar.opacity = 0;
                }
            }
            onClicked:{
                console.log('centerwindow')
                mouse.accepted = false
                mainwindow.loadingcircles = Loading.loadingfinish(mainwindow.loadingcircles)
            }
            onDoubleClicked:{
                mainwindow.loadingcircles = Loading.loading(mainwindow);
            }
        }
    }

    StatusBar{
        id:statusbar
        height: 40
        mainwindowwidth: parent.width
        mainwindowheight: parent.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "green"
        text: "Running"
    }
    MouseClick{
        anchors.fill: parent
        color: "transparent"
    }
    focus: true
    Keys.onPressed: {
        if (event.key == Qt.Key_F11){
           mainwindow.isfullscreen = !mainwindow.isfullscreen;
           mainwindow.fullscreen();
        }
        if (event.key == Qt.Key_F10){
           mainwindow.isfullscreen = !mainwindow.isfullscreen;
           mainwindow.maxClicked();
        }
        if (event.key == Qt.Key_F12){
            rightsidebar.toggleshow();
        }
        else if (event.key == Qt.Key_Up && (event.modifiers&Qt.ShiftModifier)){
            rightsidebar.stateshow('top');
        }
        else if (event.key == Qt.Key_Down && (event.modifiers&Qt.ShiftModifier)){
            rightsidebar.stateshow('bottom');
        }
        else if (event.key == Qt.Key_Left && (event.modifiers&Qt.ShiftModifier)){
            rightsidebar.stateshow('left');
        }
        else if (event.key == Qt.Key_Right && (event.modifiers&Qt.ShiftModifier)){
            rightsidebar.stateshow('right');
        }
        else if (event.key == Qt.Key_Up && (event.modifiers&Qt.ControlModifier)){
            rightsidebar.stateshow('topleft');
        }
        else if (event.key == Qt.Key_Down && (event.modifiers&Qt.ControlModifier)){
            rightsidebar.stateshow('topright');
        }
        else if (event.key == Qt.Key_Left && (event.modifiers&Qt.ControlModifier)){
            rightsidebar.stateshow('bottomleft');
        }
        else if (event.key == Qt.Key_Right && (event.modifiers&Qt.ControlModifier)){
            rightsidebar.stateshow('bottomright');
        }
    }
    Keys.onDigit0Pressed:{
        console.log("2221");
        rightsidebar.toggleshow();
    }

    Keys.onEscapePressed:{
        Qt.quit();
    }
}
