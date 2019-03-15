/*
Copyright (C) 2017 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
NSImageView subclass to display the CloudPhoto's image, allowing for copy/paste/drag and drop.
*/

import Foundation
import MediaLibrary

class PhotoView : NSImageView {

    // Delegation to notify a new photo was recevied via drag and drop, paste, or removed via delete or cut.
    var delegate: PhotoViewDelegate?
    
    let MediaPBoardType = "com.apple.MediaLibrary.PBoardType.MediaObjectIdentifiersPlist"

    func commonInit() {
        
        // Setup media library access to photos for "Copy/Paste" operations from the Photos app.
        // Don't include other source types.
        mediaLibrary.addObserver(self as Any as! NSObject,
                                 forKeyPath: MLMediaLibraryPropertyKeys.mediaSourcesKey,
                                 options: NSKeyValueObservingOptions.new,
                                 context: &mediaSourcesContext)
        
        if mediaLibrary.mediaSources != nil {} // Reference returns nil but starts the asynchronous loading.
        
        register(forDraggedTypes: [MediaPBoardType, NSPasteboardTypeTIFF, NSPasteboardTypePNG])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    deinit {
        // Make sure to remove us as an observer before "mediaLibrary" is released.
        mediaLibrary.removeObserver(self, forKeyPath: MLMediaLibraryPropertyKeys.mediaSourcesKey, context:&mediaSourcesContext)
    }
    
    // MARK: - Drag and Drop
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        commonInit()
    }
    
    func pastboardItemAllowed(pasteboard: NSPasteboard) -> Bool {
        if pasteboard.propertyList(forType: MediaPBoardType) != nil {
            return true // We accept MLMediaObjects
        } else {
            for pasteboardItem in pasteboard.pasteboardItems! {
                let fileType = (kUTTypeFileURL as NSString) as String
                if pasteboardItem.availableType(from: [fileType]) != nil {
                    return true // We accept file URLs
                } else if pasteboardItem.availableType(from: [NSPasteboardTypePNG, NSPasteboardTypeTIFF]) != nil {
                    return true // We also accept raw image data
                }
            }
        }
        return false
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard()
        if self.pastboardItemAllowed(pasteboard: pasteboard) {
            return .copy
        }
        return .generic
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return pastboardItemAllowed(pasteboard: sender.draggingPasteboard())
    }
    
    // MARK: - MLMediaLibrary

    // The KVO contexts for `MLMediaLibrary`.
    // This provides a stable address to use as the `context` parameter for KVO observation.
    private(set) var mediaSourcesContext = 1
    private(set) var rootMediaGroupContext = 2
    
    private struct MLMediaLibraryPropertyKeys {
        static let mediaSourcesKey = "mediaSources"
        static let rootMediaGroupKey = "rootMediaGroup"
        static let mediaObjectsKey = "mediaObjects"
    }
    
    // Create our media library instance to get photo pasteboard data.
    var mediaLibrary: MLMediaLibrary = {
        
        let options: [String : AnyObject] =
            [MLMediaLoadSourceTypesKey: MLMediaSourceType.image.rawValue as AnyObject,
             MLMediaLoadIncludeSourcesKey: [MLMediaSourcePhotosIdentifier, MLMediaSourceiPhotoIdentifier] as AnyObject]
        
        return MLMediaLibrary(options: options)
    }()
    
    var mediaSource: MLMediaSource!
    private var rootMediaGroup: MLMediaGroup!
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == MLMediaLibraryPropertyKeys.mediaSourcesKey && context == &mediaSourcesContext && object! is MLMediaLibrary) {
         
            // The media sources have loaded, we can access the its root media.
            if let mediaSource = self.mediaLibrary.mediaSources?[MLMediaSourcePhotosIdentifier] {
                self.mediaSource = mediaSource
            }
            else if let mediaSource = self.mediaLibrary.mediaSources?[MLMediaSourceiPhotoIdentifier] {
                self.mediaSource = mediaSource
            }
            else {
                return  // No photos found.
            }

            // Media Library is loaded now, we can access mediaSource for photos
            self.mediaSource.addObserver(self,
            forKeyPath: MLMediaLibraryPropertyKeys.rootMediaGroupKey,
            options: NSKeyValueObservingOptions.new,
            context: &rootMediaGroupContext)

            // Obtain the media grouping (reference returns nil but starts asynchronous loading).
            if (self.mediaSource.rootMediaGroup != nil) {}
        }
        else if (keyPath == MLMediaLibraryPropertyKeys.rootMediaGroupKey && context == &rootMediaGroupContext && object! is MLMediaSource) {

            // The root media group is loaded, we can access the media objects.

            // Done observing for media groups.
            self.mediaSource.removeObserver(self, forKeyPath: MLMediaLibraryPropertyKeys.rootMediaGroupKey, context:&rootMediaGroupContext)

            self.rootMediaGroup = self.mediaSource.rootMediaGroup
            self.rootMediaGroup.addObserver(self, forKeyPath: MLMediaLibraryPropertyKeys.mediaObjectsKey, options: NSKeyValueObservingOptions.new, context: nil)
         
            // Obtain the all the photos, (reference returns nil but starts asynchronous loading).
            if (self.rootMediaGroup.mediaObjects != nil) {}
        }
        else if (keyPath == MLMediaLibraryPropertyKeys.mediaObjectsKey)
        {
                
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Pasting
    
    func handlePaste(pasteboard: NSPasteboard) {
        // Reference our media library so we can load the media object from the pastboard.

        // Obtain the dictionary of MLMediaSources.
        let mediaSources = mediaLibrary.mediaSources!
        
        // We prefer to first look for a MLMediaObject.
        //
        // Obtain the media sources from the pasteboard (dictionary of media sources).
        if let mediaObjectsDict = pasteboard.propertyList(forType: MediaPBoardType) as? NSDictionary {
            
            for sourceIdentifier in mediaObjectsDict.allKeys {
                let mediaSourceTuple = mediaSources.first
                let mediaSource = (mediaSourceTuple?.1)! as MLMediaSource
                
                let objectIdentifiers = mediaObjectsDict[sourceIdentifier] as! NSArray
                
                // We only take the first photo.
                if let objectID = objectIdentifiers.firstObject {
                    let mediaObject = (mediaSource.mediaObject(forIdentifier: objectID as! String))! as MLMediaObject
                    let thumbnailURL = mediaObject.originalURL!
                    
                    if thumbnailURL.startAccessingSecurityScopedResource() {
                        // Set this view's image.
                        image = NSImage(contentsOf: thumbnailURL)
                        
                        thumbnailURL.stopAccessingSecurityScopedResource()
                        
                        // Inform our delegate an image was pasted or dropped by sending the "mediaObject", so we can use the rest of its attributes.
                        if let delegate = self.delegate {
                            delegate.didReceiveMediaObject(self, mediaObject: mediaObject)
                        }
                    }
                }
            }
        }
        else {
            // MLMediaObject not found, pasteboard might just have an image.
            if let image = NSImage(pasteboard: pasteboard) {
                if let delegate = self.delegate {
                    delegate.didReceiveImage(self, image: image)
                }
            }
        }
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        if let dragPasteboard = sender?.draggingPasteboard() {
            handlePaste(pasteboard: dragPasteboard)
        }
    }
    
    // MARK: - Edit Menu Validation
    
    // Enable Paste/Delete/Cut menu items based on photo ownership
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        var isPhotoChangeable = false
        if let delegate = self.delegate {
            isPhotoChangeable = delegate.isPhotoChangeable(self)
        }
        if menuItem.action == #selector(paste) {
            return isPhotoChangeable
        } else if menuItem.action == #selector(delete) {
            return isPhotoChangeable
        } else if menuItem.action == #selector(cut) {
            return isPhotoChangeable
        }
        // Note that Copy only copies the image itself, not the media object
        return super.validateMenuItem(menuItem)
    }
    
    // MARK: - Edit Menu Actions
    
    func paste(_ sender: Any?) {
        let pasteboard = NSPasteboard.general()
        handlePaste(pasteboard: pasteboard)
    }
    
    func delete(_ sender: Any?) {
        // Inform our delegate the image was deleted.
        if let delegate = self.delegate {
            delegate.didReceiveMediaObject(self, mediaObject: nil)
        }
    }
    
    func cut(_ sender: Any?) {
        let pasteboard = NSPasteboard.general()

        // Place the raw image onto the pasteboard.
        pasteboard.declareTypes([NSPasteboardTypeTIFF], owner: nil)
        pasteboard.writeObjects([image!])
        
        // Inform our delegate the image was cut away.
        if let delegate = self.delegate {
            delegate.didReceiveImage(self, image: nil)
        }
    }
    
}

// MARK: -

protocol PhotoViewDelegate: class {
    // Used to notify the delegate that a new photo was recevied via drag and drop, paste, or removed via delete or cut.
    func didReceiveMediaObject(_ photoView: PhotoView, mediaObject: MLMediaObject?)
    func didReceiveImage(_ photoView: PhotoView, image: NSImage?)
    
    // Used to ask our delegate if this photo is changeable.
    func isPhotoChangeable(_ photoView: PhotoView) -> Bool
}
