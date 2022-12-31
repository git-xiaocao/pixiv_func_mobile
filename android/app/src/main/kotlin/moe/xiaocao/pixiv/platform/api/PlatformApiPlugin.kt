package moe.xiaocao.pixiv.platform.api

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import moe.xiaocao.pixiv.util.newThreadFunc


class PlatformApiPlugin(context: Context) : FlutterPlugin,
    MethodChannel.MethodCallHandler {
    private val api = PlatformApi(context)

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MethodChannel(
            binding.binaryMessenger,
            api.pluginName
        ).also {
            it.setMethodCallHandler(this)
        }

    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PlatformApi.Method.SAVE_IMAGE.value -> {
                newThreadFunc(func = {
                    api.saveImage(
                        call.argument<ByteArray>("imageBytes")!!,
                        call.argument<String>("filename")!!
                    )
                }) {
                    result.success(it)
                }
            }
            PlatformApi.Method.SAVE_GIF_IMAGE.value -> {
                newThreadFunc(func = {
                    api.saveGifImage(
                        call.argument<Int>("id")!!,
                        call.argument<List<ByteArray>>("images")!!,
                        call.argument<List<Int>>("delays")!!
                    )
                }) {
                    result.success(it)
                }
            }
            PlatformApi.Method.UN_ZIP_GIF.value -> {
                newThreadFunc(func = {
                    api.unZipGif(call.argument<ByteArray>("zipBytes")!!)
                }) {
                    result.success(it)
                }
            }
            PlatformApi.Method.IMAGE_IS_EXIST.value -> {
                result.success(api.imageIsExist(call.argument<String>("filename")!!))
            }
            PlatformApi.Method.TOAST.value -> {
                api.toast(
                    call.argument<String>("content")!!,
                    call.argument<Boolean>("isLong")!!
                )
                result.success(true)
            }
            PlatformApi.Method.GET_BUILD_VERSION.value -> {
                result.success(api.getBuildVersion())
            }
            PlatformApi.Method.GET_APP_VERSION_NAME.value -> {
                result.success(api.getAppVersionName())
            }
            PlatformApi.Method.GET_APP_VERSION_CODE.value -> {
                result.success(api.getAppVersionCode())
            }
            PlatformApi.Method.URL_LAUNCH.value -> {
                result.success(api.urlLaunch(call.argument<String>("url")!!))
            }
            else -> {
                result.notImplemented()
            }
        }

    }


}
