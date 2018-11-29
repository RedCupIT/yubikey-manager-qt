import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "slotutils.js" as SlotUtils
import QtQuick.Controls.Material 2.2

ColumnLayout {

    function finish() {
        if (views.selectedSlotConfigured()) {
            otpSlotAlreadyConfigured.open()
        } else {
            programOathHotp()
        }
    }

    function programOathHotp() {
        yubiKey.programOathHotp(views.selectedSlot, secretKeyInput.text,
                                  digits.currentText, function (resp) {
                                      if (resp.success) {
                                          views.otpSuccess()
                                      } else {
                                          if (resp.error === 'write error') {
                                              views.otpWriteError()
                                          } else {
                                              views.otpFailedToConfigureErrorPopup(
                                                          resp.error)
                                          }
                                      }
                                  })
    }

    OtpSlotAlreadyConfiguredPopup {
        id: otpSlotAlreadyConfigured
        onAccepted: programOathHotp()
    }

    CustomContentColumn {
        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Heading1 {
                text: qsTr("OATH-HOTP")
            }

            BreadCrumbRow {
                items: [{
                        text: qsTr("OTP")
                    }, {
                        text: SlotUtils.slotNameCapitalized(
                                    views.selectedSlot) || ""
                    }, {
                        text: qsTr("OATH-HOTP")
                    }]
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillHeight: true
            Layout.fillWidth: true
            Label {
                text: qsTr("Secret key")
                font.pixelSize: constants.h3
                color: yubicoBlue
            }
            TextField {
                id: secretKeyInput
                Layout.fillWidth: true
                validator: RegExpValidator {
                    regExp: /[ 2-7a-zA-Z]+=*/
                }
                ToolTip.delay: 1000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Secret key must be a base32 encoded value")
                selectByMouse: true
                selectionColor: yubicoGreen
            }
        }
        RowLayout {
            Label {
                text: qsTr("Digits")
                font.pixelSize: constants.h3
                color: yubicoBlue
            }
            ComboBox {
                id: digits
                model: [6, 8]
                ToolTip.delay: 1000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Number of digits in generated code")
                Material.foreground: yubicoBlue
            }
        }

        ButtonsBar {
            finishCallback: finish
            finishEnabled: secretKeyInput.acceptableInput
            finishTooltip: qsTr("Finish and write the configuration to the YubiKey")
        }
    }
}
