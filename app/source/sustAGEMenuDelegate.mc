// Author: Adria Mallol-Ragolta, Thomas Wiest, 2019-2020

using Toybox.WatchUi;
using Toybox.System;

class sustAGEMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            System.println("item 1");
        } else if (item == :item_2) {
            System.println("item 2");
        }
    }

}