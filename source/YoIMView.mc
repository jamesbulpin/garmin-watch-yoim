import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class YoIMView extends WatchUi.View {

    private var _oneTime as Boolean = true;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        System.println("Yo onShow");
        if (_oneTime) {
            _oneTime = false;
            try {
                getApp().fetchContactList();
                var progressBar = new WatchUi.ProgressBar(
                    "Getting contacts list...",
                    null
                );
                WatchUi.pushView(
                    progressBar,
                    new YoIMWaitingDelegate(),
                    WatchUi.SLIDE_DOWN
                );
            }
            catch (ex instanceof YoMissingTokenException) {
                System.println("onShow YoMissingTokenException: " + ex.getErrorMessage());
                WatchUi.showToast("No token", {:icon=>Rez.Drawables.LauncherIcon});
            }
            catch (ex) {
                System.println("onShow exception: " + ex.getErrorMessage());
            }
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
