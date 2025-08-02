//
//  migration-sql-swiftdata.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 02/08/2025.
//

import Foundation
import SQLite
import Logging
import SwiftUI
import SwiftData


class LegacyDatabaseMigrationTool {
    
    // SwiftData new persistent storage usage
    private var modelContext: ModelContext
    
    // legacy database information
    private var db_connection: Connection!
    private var _legacy_events_table = Table("events")
    private var _legacy_db_path: String = ""
    
    let _legacy_id_column = Expression<Int64>("id")
    let _legacy_name_column = Expression<String>("name")
    let _legacy_date_column = Expression<String>("date")
    let _legacy_color1_column = Expression<String>("color1")
    let _legacy_color2_column = Expression<String>("color2")
    let _legacy_bgIMG_column = Expression<String>("bgIMG")
    
    init?(modelContext: ModelContext) {
        
        // Model context has to be passed from a view
        self.modelContext = modelContext
        
        logger.debug("Database migration tool initialising...")
        
        self._legacy_db_path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.widgetShareData.countdown")!.absoluteString
        
        do {
            self.db_connection = try Connection("\(self._legacy_db_path)/events.sqlite3")
            self._legacy_events_table = Table("events")
            
            logger.info("Database migration tool - successfully connected to legacy database at \(self._legacy_db_path)/events.sqlite3")
        } catch {
            logger.error("Database migration tool - failed to connect to legacy database at \(self._legacy_db_path)/events.sqlite3")
            
            return nil
        }
    }
    
    func migrate() {
        
        var db_query: AnySequence<Row>
        
        do {
            db_query = try self.db_connection.prepare(_legacy_events_table)

        } catch {
            logger.error("Failed to migrate: \(error.localizedDescription)")
            
            return
        }
        
        for _legacy_event in db_query {
            
            let temp_event_name: String = _legacy_event[_legacy_name_column]
            let temp_event_date: Date = leg_date_parse(_legacy_event[_legacy_date_column])
            let temp_event_color1: Color = leg_color_parse(_legacy_event[_legacy_color1_column])
            let temp_event_color2: Color = leg_color_parse(_legacy_event[_legacy_color2_column])
            var temp_event_bgIMG: Data? = nil
            
            if _legacy_event[_legacy_bgIMG_column] != "" {
                temp_event_bgIMG = leg_image_parse(_legacy_event[_legacy_bgIMG_column])
            }
            
            let event_to_add = Event(
                timestamp: temp_event_date,
                name: temp_event_name,
                image: temp_event_bgIMG,
                gradient_colors: [temp_event_color1, temp_event_color2]
            )
            
            modelContext.insert(event_to_add)
        }
    }
    
    func leg_date_parse(_ date_string: String) -> Date {
        
        let date_formater = DateFormatter()
        date_formater.dateFormat = "yyyy-MM-dd"
        let date_object = date_formater.date(from: date_string) ?? .distantFuture
        
        return date_object
    }
    
    func leg_color_parse(_ color_string: String) -> Color {
        
        let split_up_color = color_string.components(separatedBy: ",")
        let color = Color(red: (split_up_color[0] as NSString).doubleValue, green: (split_up_color[1] as NSString).doubleValue, blue: (split_up_color[2] as NSString).doubleValue)
        
        return color
    }
    
    func leg_image_parse(_ img_string: String) -> Data? {
        // the code below is identical to the code in legacy app, to ensure no differences
        let dataDecoded = Data(base64Encoded: img_string, options: .ignoreUnknownCharacters)
        
        if dataDecoded != nil {
            return dataDecoded
        }
        
        return nil
    }
 
}

