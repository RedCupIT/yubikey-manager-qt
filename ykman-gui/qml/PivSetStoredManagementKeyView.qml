import QtQuick 2.9
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

PivSetManagementKeyView {

    breadcrumbs: [{
                text: qsTr("PIV")
            }, {
                text: qsTr("Configure PINs")
            }, {
                text: qsTr("Management Key Type")
            }, {
                text: qsTr("PIN as Management Key")
            }]
    hasNewManagementKeyInput: false
    hasPinInput: true
    heading: qsTr("Set PIN as Management Key")
    storeManagementKey: true

}
