import QtQuick
import Hel.Config
import qs.components
import qs.components.controls
import qs.services
import qs.utils

Item {
    id: root

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: Tokens.sizes.bar.innerWidth * 3

    CustomMouseArea {
        function onWheel(event: WheelEvent): void {
            if (event.angleDelta.y > 0)
                Audio.incrementVolume();
            else if (event.angleDelta.y < 0)
                Audio.decrementVolume();
        }

        anchors.fill: parent

        FilledSlider {
            anchors.fill: parent

            icon: Icons.getVolumeIcon(value, Audio.muted)
            value: Audio.volume
            to: GlobalConfig.services.maxVolume
            onMoved: Audio.setVolume(value)
        }
    }
}
