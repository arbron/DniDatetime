//
//  DniDateTimeFormatter.swift
//  Basic Clock
//
//  Created by Jeff Hitchcock on 2016-09-27.
//  Copyright © 2016 Jeff Hitchcock. All rights reserved.
//

import Foundation

public final class DniDateTimeFormatter: Formatter {
    public enum Style {
        case none, short, medium, long, full
        /* Date Formats
            Short:
            Medium:
            Long:
           Time Formats
            Short:      Pt:T:G
            Medium:
            Long:
            Full:       Pt:T:G:P
        */
    }

    public var useGahrtahvo = false
    public var dateFormat = Style.full
    public var timeFormat = Style.medium
    public var dateTimeSeperator = " "
    
    public func string(from date: DniDateTime) -> String {
        var dateComponent = ""
        if dateFormat == .full {
            dateComponent = "\(date.hahrtee) \(DniDateTimeUnit.Vailee(rawValue: date.vaileetee)!.name) \(date.yahrtee)"
        } else if dateFormat == .long {
            dateComponent = "\(date.hahrtee).\(date.vaileetee).\(date.yahrtee)"
        } else if dateFormat == .medium {
            dateComponent = "\(DniDateTimeUnit.Vailee(rawValue: date.vaileetee)!.name) \(date.yahrtee)"
        } else if dateFormat == .short {
            dateComponent = "\(date.vaileetee).\(date.yahrtee)"
        }

        var timeComponent = ""
        if timeFormat == .full {
            timeComponent = "\(date.pahrtahvotee):\(date.tahvotee):\(date.gorahntee):\(date.prorahntee)"
        } else if timeFormat == .long {
            timeComponent = ""
        } else if timeFormat == .medium {
            timeComponent = ""
        } else if timeFormat == .short {
            timeComponent = ""
        }

        let seperator = (dateComponent != "" && timeComponent != "") ? dateTimeSeperator : ""

        return "\(dateComponent)\(seperator)\(timeComponent)"
    }
    /*
    
    func date(from string: String) -> DniDateTime {
        return DniDateTime()
    }
    */
}
