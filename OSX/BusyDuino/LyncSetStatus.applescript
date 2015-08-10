# The Lync API
#
# @module LyncSetStatus
# @author Sebastian Mandrean
# @date 10 Aug 2015
# @copyright Sebastian Mandrean 2015
# @license MIT

#!/usr/bin/osascript

on run argv
    set status to (item 1 of argv)

    --Set Lync status
    tell application "Microsoft Lync"
        activate
    end tell

    tell application "System Events"
        tell process "Microsoft Lync"
            tell menu bar 1
                tell menu bar item "Status"
                    tell menu "Status"
                        click menu item status
                    end tell
                end tell
            end tell
        end tell
    end tell

end run
