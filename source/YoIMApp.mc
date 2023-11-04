import Toybox.Application;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

class YoIMApp extends Application.AppBase {

    private var _awaitingContacts as Boolean = true;
    private var _contacts as Array<String> or Null;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new YoIMView(), new YoIMDelegate() ] as Array<Views or InputDelegates>;
    }

    function fetchContactList() as Void {
        makeApiCall("contacts", Communications.HTTP_REQUEST_METHOD_GET, null, Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON, method(:onResponseContacts));
    }

    function onResponseContacts(responseCode as Number, data as Dictionary) as Void {
        System.println("Yo onResponseContacts code=" + responseCode);
        if (responseCode == 200) {
            System.println("Yo onResponseContacts: " + data.toString());
            if (data instanceof Array) {
                _contacts = data as Array<String>;
                if (_awaitingContacts) {
                    _awaitingContacts = false;
                }
            }
        }
        onContactListFetch(!_awaitingContacts);
        WatchUi.requestUpdate();
    }

    function sendYo(contact as String) as Void {
        makeApiCall("yo", Communications.HTTP_REQUEST_METHOD_POST, {"username" => contact}, Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN, method(:onResponseYo));
    }

    function onResponseYo(responseCode as Number, data as Dictionary) as Void {
        System.println("Yo onResponseYo code=" + responseCode);
        if ((responseCode == 200) || (responseCode == 202)) {
            WatchUi.showToast("Yo sent!", {:icon=>Rez.Drawables.LauncherIcon});
        }
        else {
            WatchUi.showToast("Failed to send Yo", {:icon=>Rez.Drawables.LauncherIcon});
        }
    }

    function onContactListFetch(success as Boolean) as Void {
        if (success) {
            System.println("contacts: " + _contacts.toString());
            var menu = new WatchUi.CustomMenu(100, Graphics.COLOR_BLACK, {:title=>new $.ContactListTitle()});
            for (var i = 0; i < _contacts.size(); i++) {
                var contact = _contacts[i] as String;
                menu.addItem(new ContactListItemRoom(contact, contact, CONTACT_LIST_COLORS[i % CONTACT_LIST_COLORS.size()]));
            }
            WatchUi.pushView(menu, new $.YoIMMenuDelegate(), WatchUi.SLIDE_UP);
        }
        else {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            WatchUi.showToast("Failed to fetch contacts", {:icon=>Rez.Drawables.LauncherIcon});
        }
    }

    private function makeApiCall(endpoint as String, method as Communications.HttpRequestMethod, payload as Dictionary or Null, responseType as Communications.HttpResponseContentType, callback as Method(responseCode as Number, data as Dictionary) as Void) {
        var token = Properties.getValue("token_prop");
        if (token.length() == 0) {
            throw new YoMissingTokenException();
        }

        var options = {
            :method => method,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :responseType => responseType
        };

        var url = "https://api.yo.im/" + endpoint;
        
        switch (method) {
        case Communications.HTTP_REQUEST_METHOD_GET:
        case Communications.HTTP_REQUEST_METHOD_DELETE:
            url += "?api_token=" + token;
            break;
        default:
            if (payload == null) {
                payload = {};
            }
            payload.put("api_token", token);
            break;
        }

        Communications.makeWebRequest(url, payload, options, callback);
    }

}

function getApp() as YoIMApp {
    return Application.getApp() as YoIMApp;
}

class YoException extends Lang.Exception {
    function initialize(msg) {
        Exception.initialize();
        self.mMessage = msg;
    }
}

class YoMissingTokenException extends YoException {
    function initialize() {
        YoException.initialize("Missing token");
    }
}