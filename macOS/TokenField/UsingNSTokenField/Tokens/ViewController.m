/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Main view controller for this sample.
 */

#import "ViewController.h"
#import "MyToken.h"
#import "CustomView.h"

@interface ViewController () <NSTokenFieldDelegate>

@property (weak) IBOutlet NSTokenField *tokensField;
@property (weak) IBOutlet NSPopUpButton *namesPopup;
@property (weak) IBOutlet NSButton *useTokenMenu;
@property (weak) IBOutlet NSButton *useCustomTokenMenu;

@property (strong) IBOutlet CustomView *customMenuView; // menu used for custom menu item views

@property (strong) NSMenu *tokenMenu;   // the menu attached to each token
@property (strong) NSMenu *customMenu;   // the menu attached to each token, but display a custom view from 'customMenuItemView'

@property (strong) NSMutableArray *builtInKeywords;
@property (strong) NSArray *matches;

@property (strong) MyToken *menuToken;

@end


#pragma mark -

@implementation ViewController

// -------------------------------------------------------------------------------
//	awakeFromNib
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
    // the default tokenizing character is the comma; carriage return (or newline character)
    //
    // example how to make the tokenize character with "/"
    /*
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    [self.tokensField setTokenizingCharacterSet:set];
    */
    
    self.tokensField.tokenStyle = NSTokenStyleDefault;
    self.tokensField.delegate = self;           // this can also be done in Interface Builder
    self.tokensField.completionDelay = 0.5;     // slow down auto completion a bit for type matching
    
    // create the token menu (to allow for the user to edit it)
    _tokenMenu = [[NSMenu alloc] initWithTitle:@""];
    [self.tokenMenu insertItem:[[NSMenuItem alloc] initWithTitle:@"Edit…"
                                                          action:@selector(editCellAction:)
                                                   keyEquivalent:@""] atIndex:0];
    
    // build our type completion list of names
    // (copy off the menu item title to a separate array for type completion matching)
    //
    _builtInKeywords = [[NSMutableArray alloc] init];
    for (NSMenuItem *menuItem in self.namesPopup.menu.itemArray)
    {
        [self.builtInKeywords addObject:menuItem.title];
    }
    
    // create our custom menu item view
    _customMenu = [[NSMenu alloc] initWithTitle:@"Custom"];
    NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:@"Custom" action:nil keyEquivalent:@""];
    newItem.view = self.customMenuView;
    [self.customMenu insertItem:newItem atIndex:0];
}


#pragma mark - NSTokenFieldDelegate

// ---------------------------------------------------------------------------
//	styleForRepresentedObject:representedObject
//
//	Make sure our tokens are rounded.
// ---------------------------------------------------------------------------
- (NSTokenStyle)tokenField:(NSTokenField *)tokenField styleForRepresentedObject:(id)representedObject
{
    return NSTokenStyleRounded;
}

// ---------------------------------------------------------------------------
//	hasMenuForRepresentedObject:representedObject
//
//	Make sure our tokens have a menu. By default tokens have no menus.
// ---------------------------------------------------------------------------
- (BOOL)tokenField:(NSTokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject
{
    return self.useTokenMenu.state == NSOnState;
}

// ---------------------------------------------------------------------------
//	menuForRepresentedObject:representedObject
//
//	User clicked on a token, return the menu we want to represent for our token.
//	By default tokens have no menus.
// ---------------------------------------------------------------------------
- (NSMenu *)tokenField:(NSTokenField *)tokenField menuForRepresentedObject:(id)representedObject
{
    NSMenu *returnMenu = nil;
    
    if (self.useTokenMenu.state == NSOnState)
    {
        _menuToken = representedObject;
        returnMenu = (self.useCustomTokenMenu.state == NSOnState) ? self.customMenu : self.tokenMenu;
    }
    else
    {
        // note: representedObject is the actual NSToken
        //
        if ([representedObject isKindOfClass:[MyToken class]])
        {
            returnMenu = (self.useCustomTokenMenu.state == NSOnState) ? self.customMenu : self.tokenMenu;
        }
    }
    
    return returnMenu;
}

// ---------------------------------------------------------------------------
//	completionsForSubstring:substring:tokenIndex:selectedIndex
//
//	Called 1st, and again every time a completion delay finishes.
//
//	substring =		the partial string that to be completed.
//	tokenIndex =	the index of the token being edited.
//	selectedIndex = allows you to return by-reference an index in the array
//					specifying which of the completions should be initially selected.
// ---------------------------------------------------------------------------
- (NSArray *)tokenField:(NSTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex
    indexOfSelectedItem:(NSInteger *)selectedIndex
{
    self.matches = [self.builtInKeywords filteredArrayUsingPredicate:
                    [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", substring]];
    return self.matches;
}

// ---------------------------------------------------------------------------
//	representedObjectForEditingString:editingString
//
//	Called 2nd, after you choose a choice from the menu list and press return.
//
//	The represented object must implement the NSCoding protocol.
//	If your application uses some object other than an NSString for their represented objects,
//	you should return a new instance of that object from this method.
//
// ---------------------------------------------------------------------------
- (id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString
{
    id returnRepresentedObject = nil;
    
    if (self.useTokenMenu.state == NSOnState)
    {
        MyToken *token = [[MyToken alloc] init];
        token.name = editingString;
        returnRepresentedObject = token;
    }
    else
    {
        NSArray *foundItems =
            [self.matches filteredArrayUsingPredicate:
                [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", editingString]];
        NSString *foundString = foundItems.firstObject;
        if (foundString.length > 0)
        {
            MyToken *token = [[MyToken alloc] init];
            token.name = foundString;
            returnRepresentedObject = token;
        }
    }
    
    return returnRepresentedObject;
}

// ---------------------------------------------------------------------------
//	displayStringForRepresentedObject:representedObject
//
//	Called 3rd, once the token is ready to be displayed.
//
//	If you return nil or do not implement this method, then representedObject
//	is displayed as the string. The represented object must implement the NSCoding protocol.
// ---------------------------------------------------------------------------
- (NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject
{
    NSString *string = nil;
    
    if ([representedObject isKindOfClass:[MyToken class]])	// check to see if the object is our token class
    {
        MyToken *token = representedObject;
        string = token.name;
    }
    else
    {
        string = representedObject;
    }
    return string;
}


#pragma mark - Actions

// ---------------------------------------------------------------------------
//	tokenFieldAction:sender
//
//	The action-message selector associated with this NSTokenField.
//	Called when the user commits an edit by pressing return key.
// ---------------------------------------------------------------------------
- (IBAction)tokenFieldAction:(id)sender
{
    NSText *fieldEditor = [self.tokensField currentEditor];
    
    NSRange textRange = fieldEditor.selectedRange;
    if (textRange.length > 0)
    {
        NSString *replacedString = [NSString stringWithString:self.menuToken.name];
        [fieldEditor replaceCharactersInRange:textRange withString:replacedString];
        fieldEditor.selectedRange = NSMakeRange(textRange.location, replacedString.length);
    }
}

// ---------------------------------------------------------------------------
//	addTokenAction:sender
//
//	User wants to add a token (from the "Add" button)
// ---------------------------------------------------------------------------
- (IBAction)addTokenAction:(id)sender
{
    // first find the right name to apply to the token
    NSString *nameStr = self.namesPopup.titleOfSelectedItem;
    
    // get the array of tokens
    NSArray *array = self.tokensField.objectValue;
    
    // copy the array so we can modify and add a new one
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
    
    MyToken *token = [[MyToken alloc] init];
    token.name = nameStr;
    
    [newArray addObject:token];
    self.tokensField.objectValue = newArray; // commit the edit change
    
    // force the insertion point after the added token
    NSText *fieldEditor = self.tokensField.currentEditor;
    fieldEditor.selectedRange = NSMakeRange(fieldEditor.string.length, 0);
}

// ---------------------------------------------------------------------------
//	editCellAction:sender
//
//	The user chose "Edit…" from the token menu.
// ---------------------------------------------------------------------------
- (IBAction)editCellAction:(id)sender
{
    if (self.useCustomTokenMenu.state == NSOnState)
    {
        // the edit button from the custon view called us to edit the token value,
        // we need to close our custom menu here
        [self.customMenu cancelTracking];
    }
    
    NSText *fieldEditor = [self.tokensField currentEditor];
    NSRange textRange = fieldEditor.selectedRange;
    
    NSString *replacedString = [NSString stringWithString:self.menuToken.name];
    [fieldEditor replaceCharactersInRange:textRange withString:replacedString];
    fieldEditor.selectedRange = NSMakeRange(textRange.location, replacedString.length);
}

- (IBAction)useTokenMenu:(id)sender
{
    NSButton *useTokenMenuCheckbox = (NSButton *)sender;
    self.useCustomTokenMenu.enabled = (useTokenMenuCheckbox.state == NSOnState);
}


@end
