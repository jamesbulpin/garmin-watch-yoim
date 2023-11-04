import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class YoIMWaitingDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() as Boolean {
        System.exit();
    }
}