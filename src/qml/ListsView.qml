import QtQuick 1.1
import com.nokia.meego 1.0
import 'constants.js' as UIConstants
import 'storage.js' as Storage

Page {
    id: listsView

    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: {
                appWindow.pageStack.pop()
            }
        }
    }

    Component.onCompleted: {
        // Due to a limitation in the ListModel, translating its elements
        // must be done this way

        //: Shown as the title for the favorites menu entry
        //% "Favorites"
        listsModel.get(0).title = qsTrId('btc-favorites-title')
        //: Shown as the subtitle for the favorites menu entry
        //% "Your favorite movies and celebrities"
        listsModel.get(0).subtitle = qsTrId('btc-favorites-subtitle')

        //: Shown as the title for the watchlist menu entry
        //% "Watchlist"
        listsModel.get(1).title = qsTrId('btc-watchlist-title')
        //: Shown as the subtitle for the watchlist menu entry
        //% "Movies you've saved to watch later"
        listsModel.get(1).subtitle = qsTrId('btc-watchlist-subtitle')
    }

    property string headerText: ''

    ListModel {
        id: listsModel

        ListElement {
            title: 'Favorites'
            subtitle: 'Your favorite movies and celebrities'
            action: 0
        }

        ListElement {
            title: 'Watchlist'
            subtitle: 'Movies you\'ve saved to watch later'
            action: 1
        }
    }

    Component { id: favoritesView; FavoritesView { } }

    ListView {
        id: list
        anchors.fill: parent
        height: (appWindow.inPortrait ?
                     UIConstants.HEADER_DEFAULT_HEIGHT_PORTRAIT :
                     UIConstants.HEADER_DEFAULT_HEIGHT_LANDSCAPE) +
                    listsModel.count * UIConstants.LIST_ITEM_HEIGHT_DEFAULT
        model: listsModel
        clip: true
        interactive: false
        delegate: MyListDelegate {
            width: parent.width
            title: model.title
            subtitle: model.subtitle

            onClicked: {
                switch (action) {
                case 0:
                    appWindow.pageStack.push(favoritesView, {
                                                 headerText: model.title,
                                                 state: 'favorites'
                                             })
                    break;
                case 1:
                    appWindow.pageStack.push(favoritesView, {
                                                 headerText: model.title,
                                                 state: 'watchlist'
                                             })
                    break;
                default:
                    console.debug('Action not available')
                    break
                }
            }
        }
        header: Header {
            text: headerText
        }
    }
}