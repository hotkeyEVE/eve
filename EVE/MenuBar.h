/*
  MenuBar.h
  EVE

  Created by Tobias Sommer on 6/13/12.
  Copyright (c) 2012 Sommer. All rights reserved.

This file is part of EVE.

EVE is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

EVE is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with EVE.  If not, see <http://www.gnu.org/licenses/>. */

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface MenuBar : NSObject {
    IBOutlet NSMenu         *theMenu;
    IBOutlet NSMenuItem     *PauseMenuItem;
    IBOutlet NSMenuItem     *indexing;
    IBOutlet NSMenuItem     *resetDatabase;
  
}
@property NSInteger currentFrame;
@property(strong) NSTimer* animTimer;
@property(strong) NSImage *eve_icon_active;
@property(strong) NSImage *eve_icon_disabled;
@property(strong) NSImage *eve_icon_learned;
@property(strong) NSImage *eve_icon_no_gui;
@property(strong) NSStatusItem *statusItem;
@property BOOL indexingIsRunning;

- (IBAction)exitProgram:(id)sender;
- (IBAction)contactMe:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)visitWebsite:(id)sender;
- (IBAction) resetDatabase:(id)sender;
- (IBAction) indexingThisAppAgain:(id)sender;

- (void) setShortcutCount :(int) count;

- (void) setMenuBarIconToDisabled;
- (void) setMenuBarIconToActive;
- (void) setMenuBarIconToNoGUI;

- (void) setMenuBarIconToDisabledDelayActive;
- (void) delay:(id)param;
- (NSString*) getIconName;

- (void)startAnimating;
- (void)stopAnimating;
- (void)updateImage;

@end
