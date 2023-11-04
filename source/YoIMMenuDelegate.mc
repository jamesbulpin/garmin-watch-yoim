import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class YoIMMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(item as MenuItem) as Void {
        getApp().sendYo(item.getId() as String);
    }

    public function onBack() as Void {
        System.exit();
    }
}