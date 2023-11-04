import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

var CONTACT_LIST_COLORS as Array<Graphics.ColorType> = [
    Graphics.COLOR_DK_GREEN,
    Graphics.COLOR_DK_BLUE,
    Graphics.COLOR_DK_GRAY,
    Graphics.COLOR_ORANGE,
    Graphics.COLOR_PURPLE,
    Graphics.COLOR_RED
] as Array<Graphics.ColorType>;

//! This is the custom drawable we will use for our main menu title
class ContactListTitle extends WatchUi.Drawable {

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
    }

    //! Draw the application icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var menuTitle = "Yo.IM";

        var labelX = dc.getWidth() / 2;
        var labelY = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(labelX, labelY, Graphics.FONT_MEDIUM, menuTitle, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}

class ContactListItemRoom extends WatchUi.CustomMenuItem {

    private var _label as String;
    private var _color as Graphics.ColorType;

    public function initialize(id as String, label as String, color as Graphics.ColorType) {
        CustomMenuItem.initialize(id, {});
        _label = label;
        _color = color;
    }

    //! Draw the item string at the center of the item.
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        dc.setColor(_color, _color);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
