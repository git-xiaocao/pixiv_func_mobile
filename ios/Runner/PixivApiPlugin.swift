import Flutter
import UIKit
import ZIPFoundation
import Photos

public class PixivApiPlugin: NSObject, FlutterPlugin {
    private static let pluginName = "xiaocao/platform/api"
    private unowned let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }


    public static func register(with registrar: FlutterPluginRegistrar) {
        //won't do anything...
    }


    public static func register(with registrar: FlutterPluginRegistrar, window: UIWindow) {
        let channel = FlutterMethodChannel(name: pluginName, binaryMessenger: registrar.messenger())
        let instance = PixivApiPlugin(window: window)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        guard let method = Method(rawValue: call.method) else {
            return result(FlutterMethodNotImplemented)
        }

        switch (method) {
        case .saveImage:
            let args = call.arguments as! Dictionary<String, Any>

            DispatchQueue.global(qos: .userInitiated).async {
                PixivApi.saveImage(
                        imageBytes: (args["imageBytes"] as! FlutterStandardTypedData).data,
                        filename: args["filename"] as! String
                ) { (success: BooleanLiteralType) in
                    result(success)
                }
            }

        case .saveGifImage:
            let args = call.arguments as! Dictionary<String, Any>
            DispatchQueue.global(qos: .userInitiated).async {
                PixivApi.saveGif(
                        id: args["id"] as! Int,
                        images: (args["images"] as! FlutterStandardTypedData).data,
                        delays: (args["delays"] as! FlutterStandardTypedData).intArray
                ) { (success: BooleanLiteralType) in
                    result(success)
                }
            }

        case .unZipGif:
            let args = call.arguments as! Dictionary<String, Any>
            DispatchQueue.global(qos: .userInitiated).async {
                result(PixivApi.unZipGif(zipBytes: (args["zipBytes"] as! FlutterStandardTypedData).data))
            }

        case .imageIsExist:
            let args = call.arguments as! Dictionary<String, Any>
            result(PixivApi.imageIsExist(filename: args["filename"] as! String))

        case .getAppVersionCode:

            result(PixivApi.getVersionCode())

        case .getAppVersionName:

            result(PixivApi.getVersionName())

        case .urlLaunch:
            let args = call.arguments as! Dictionary<String, Any>
            result(PixivApi.urlLaunch(url: args["url"] as! String))
        }
    }

    private enum Method: String, CaseIterable & Hashable {
        case saveImage = "saveImage"
        case saveGifImage = "saveGifImage"
        case unZipGif = "unZipGif"
        case imageIsExist = "imageIsExist"
        case getAppVersionName = "getAppVersionName"
        case getAppVersionCode = "getAppVersionCode"
        case urlLaunch = "urlLaunch"
    }
}


internal class PixivApi {

    /// 保存图片
    ///
    /// - Parameters:
    ///   - imageBytes: 图片bytes
    ///   - filename: 文件名
    ///   - completion: 完成回调 -> BooleanLiteralType
    static func saveImage(imageBytes: Data, filename: String, completion: ((BooleanLiteralType) -> Void)?) {
        let albumName = "PixivFunc"

        var assetAlbum: PHAssetCollection?
        //看保存的指定相册是否存在
        let list = PHAssetCollection
                .fetchAssetCollections(with: .album, subtype: .any, options: nil)
        list.enumerateObjects({ (album, index, stop) in
            let assetCollection = album
            if albumName == assetCollection.localizedTitle {
                assetAlbum = assetCollection
                stop.initialize(to: true)
            }
        })
        //不存在的话则创建该相册
        if assetAlbum == nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest
                        .creationRequestForAssetCollection(withTitle: albumName)
            }, completionHandler: { (isSuccess, error) in
                saveImage(imageBytes: imageBytes, filename: filename, completion: completion)
            })
            return
        }

        //保存图片
        PHPhotoLibrary.shared().performChanges({
            //添加的相机胶卷
            let request = PHAssetCreationRequest.forAsset()

            let createOptions = PHAssetResourceCreationOptions()
            createOptions.originalFilename = filename
            request.addResource(with: PHAssetResourceType.photo, data: imageBytes, options: createOptions)

            //添加到相簿

            let assetPlaceholder = request.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetAlbum!)
            albumChangeRequest!.addAssets([assetPlaceholder!] as NSArray)

        }) { (isSuccess, error) in
            if isSuccess {
                completion?(true)
            } else {
                print(error!.localizedDescription)
                completion?(false)
            }
        }
    }


    /// 保存GIF图片
    ///
    /// - Parameters:
    ///   - id: 插画id
    ///   - images: 图片数据数组
    ///   - delays: 每一帧的时长
    ///   - completion: 完成回调 -> BooleanLiteralType
    static func saveGif(id: Int, images: Array<Data>, delays: Array<Int>, completion: ((BooleanLiteralType) -> Void)?) {
        let tempGifFileURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".gif")

        guard let destination = CGImageDestinationCreateWithURL(
                tempGifFileURL as NSURL,
                kCMMetadataBaseDataType_GIF,
                images.count,
                nil
        )
        else {
            completion?(false)
            return
        }
        //        设置每帧图片播放时间
        let cgimageDic = [kCGImagePropertyGIFDelayTime as String: 0.1]
        let gifDestinationDic = [kCGImagePropertyGIFDictionary as String: cgimageDic]
        let length = delays.count
        //添加gif图像的每一帧元素
        for i in 0..<length {
            let imageData = images[i * length..<(i + 1) * length]
            if let cgimage = UIImage(data: imageData)?.cgImage {
                CGImageDestinationAddImage(destination, cgimage, gifDestinationDic as CFDictionary)
            } else {
                completion?(false)
                return
            }
        }

        //         设置gif的彩色空间格式、颜色深度、执行次数
        let gifPropertyDic = NSMutableDictionary()
        gifPropertyDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String)
        gifPropertyDic.setValue(16, forKey: kCGImagePropertyDepth as String)
        gifPropertyDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String)

        //设置gif属性
        let gifDicDest = [kCGImagePropertyGIFDictionary as String: gifPropertyDic]
        CGImageDestinationSetProperties(destination, gifDicDest as CFDictionary)

        //生成gif
        if CGImageDestinationFinalize(destination) {
            do {
                try saveImage(
                        imageBytes: Data(contentsOf: tempGifFileURL),
                        filename: "\(id).gif",
                        completion: completion
                )
            } catch {
                print("异常:\(error)")
                completion?(false)
            }
        }
    }

    /// 解压缩
    ///
    /// - Parameter zipBytes: 压缩包文件bytes
    /// - Returns: 文件bytes数组
    static func unZipGif(zipBytes: Data) -> [Data] {
        var list = [Data]();

        let fileManager = FileManager.default

        // 临时文件
        let tempZipFilePath = NSTemporaryDirectory() + UUID().uuidString + ".zip"
        // 临时文件夹
        let tempUnZipDirectorPath = NSTemporaryDirectory() + UUID().uuidString
        print(tempZipFilePath)
        print(tempUnZipDirectorPath)

        do {
            // 创建临时文件把压缩包数据写进去
            try fileManager.createFile(atPath: tempZipFilePath, contents: zipBytes)
            // 创建临时文件夹用来存放解压之后的文件
            try fileManager.createDirectory(atPath: tempUnZipDirectorPath, withIntermediateDirectories: true, attributes: nil)
            // 解压压缩文件
            try fileManager.unzipItem(at: URL(fileURLWithPath: tempZipFilePath), to: URL(fileURLWithPath: tempUnZipDirectorPath))
            // 遍历刚才解压好的文件
            for fileName in try fileManager.contentsOfDirectory(atPath: tempUnZipDirectorPath) {
                // 拼接文件全路径
                let fullFilePath = "\(tempUnZipDirectorPath)/\(fileName)"
                list.append(try Data(contentsOf: URL(fileURLWithPath: fullFilePath)));
            }
        } catch {
            print("解压异常: \(error)")
        }
        do {
            // 删除临时文件和目录
            try fileManager.removeItem(atPath: tempZipFilePath)
            try fileManager.removeItem(atPath: tempUnZipDirectorPath)
        } catch {
            print("删除临时文件异常: \(error)")
        }

        return list
    }


    /// 图片是否存在
    ///
    /// - Parameter filename: 文件名
    /// - Returns: 是否存在
    static func imageIsExist(filename: String) -> BooleanLiteralType {

        var exist: BooleanLiteralType = false
        var assetAlbum: PHAssetCollection?
        //看保存的指定相册是否存在
        let list = PHAssetCollection
                .fetchAssetCollections(with: .album, subtype: .any, options: nil)
        list.enumerateObjects({ (album, index, stop) in
            let assetCollection = album
            if "PixivFunc" == assetCollection.localizedTitle {
                assetAlbum = assetCollection
                stop.initialize(to: true)
            }
        })
        if assetAlbum != nil {
            let fetchResult = PHAsset.fetchAssets(in: assetAlbum!, options: nil)
            if fetchResult.count > 0 {
                fetchResult.enumerateObjects({ (asset, index, stop) in
                    let resource = PHAssetResource.assetResources(for: asset)
                    let originalFilename = resource.first?.originalFilename ?? "unknown"
                    if filename == originalFilename {
                        exist = true
                        stop.initialize(to: true)
                    }

                })
            }
        }
        return exist
    }


    /// 内部版本
    /// - Returns: BundleVersion
    static func getVersionCode() -> Int {
        Int(Bundle.main.infoDictionary?["CFBundleVersion"] as! String) ?? 0
    }

    /// VersionName
    /// - Returns: App外部版本
    static func getVersionName() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }


    /// 启动URL
    /// - Parameter url: urlString
    /// - Returns: 是否成功
    static func urlLaunch(url: String) -> NSNumber.BooleanLiteralType {
        if let url = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                return false
            }
            return true
        }
        return false
    }
}
