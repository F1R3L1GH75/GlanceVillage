package com.firelights.glance

import android.os.Bundle
import android.os.SystemClock
import com.mantra.mfs100.*
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity(), MFS100Event {
    private val CHANNEL = "com.firelights.glance/fingerprint"
    private lateinit var channel: MethodChannel

    var timeout = 10000
    var mfs100: MFS100? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        try {
            mfs100 = MFS100(this)
            mfs100!!.SetApplicationContext(this)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onStart() {
        try {
            if (mfs100 == null) {
                mfs100 = MFS100(this)
                mfs100!!.SetApplicationContext(this)
            } else {
                initScanner()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        super.onStart()
    }

    override fun onStop() {
        try {
            if (mfs100 != null) {
                mfs100!!.UnInit()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        super.onStop()
    }

    override fun onDestroy() {
        try {
            if (mfs100 != null) {
                mfs100!!.Dispose()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
            if (call.method == "verifyFingerprint") {
                val args = call.arguments as ByteArray
                //val fingerprintData = args["fingerprint"]
                //val fingerprintData = args
                val capturedFingerData = captureFinger()
                Log.e("Fingerprint", args.joinToString("") { "%02x".format(it) })
                Log.e("CapturedFingerprint", capturedFingerData.joinToString("") { "%02x".format(it) })
                val ret = mfs100!!.MatchANSI(capturedFingerData, args, 0)
                if (ret >= 0) {
                    Log.e("Match", ret.toString())
                    if(ret >= 96) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                } else {
                    result.error("Verification failed", mfs100!!.GetErrorMsg(ret), null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun initScanner() {
        try {
            val ret = mfs100!!.Init()
            if (ret != 0) {
                Log.e("Error",mfs100!!.GetErrorMsg(ret))
            } else {
                Log.e("Success","Init success")
                val info = """Serial: ${mfs100!!.GetDeviceInfo().SerialNo()} Make: ${mfs100!!.GetDeviceInfo().Make()} Model: ${mfs100!!.GetDeviceInfo().Model()}
Certificate: ${mfs100!!.GetCertification()}"""
                Log.e("Log",info)
            }
        } catch (ex: Exception) {
            //Toast.makeText(applicationContext, "Init failed, unhandled exception", Toast.LENGTH_LONG).show()            
            Log.e("Error","Init failed, unhandled exception")
        }
    }

    private fun unInitScanner() {
        try {
            val ret = mfs100!!.UnInit()
            if (ret != 0) {
                Log.e("Error", mfs100!!.GetErrorMsg(ret))
            } else {
                Log.e("Success","Uninit Success")
            }
        } catch (e: Exception) {
            Log.e("UnInitScanner.EX", e.toString())
        }
    }

    private fun captureFinger() : ByteArray {
        val ansiTemplate = ByteArray(2000)
//        Thread {
            try {
                var fingerData = FingerData();
                var ret = mfs100!!.AutoCapture(fingerData, timeout, true);
                if (ret != 0) {
                    print(mfs100!!.GetErrorMsg(ret));
                } else {
                    print("Capture Success");
                    val rawData = fingerData.RawData()
                    ret = mfs100!!.ExtractANSITemplate(rawData, ansiTemplate);
                    if (ret <= 0) {
                        print(mfs100!!.GetErrorMsg(ret));
                    } else {
                        print("Extract ANSI Template Success");
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
//        }.start();
        return ansiTemplate;
    }

    private var mLastAttTime = 0L
    override fun OnDeviceAttached(vid: Int, pid: Int, hasPermission: Boolean) {
        if (SystemClock.elapsedRealtime() - mLastAttTime < 1500) {
            return;
        }
        mLastAttTime = SystemClock.elapsedRealtime()
        if (!hasPermission) {
            print("Permission denied")
            return
        }
        try {
            if (vid == 1204 || vid == 11279) {
                if (pid == 34323) {
                    val ret = mfs100!!.LoadFirmware();
                    if (ret != 0) {
                        print(mfs100!!.GetErrorMsg(ret));
                    } else {
                        print("Load firmware success");
                    }
                } else if (pid == 4101) {
                    val key = "Without Key"
                    val ret = mfs100!!.Init();
                    if (ret == 0) {
                        print(key);
                    } else {
                        print(mfs100!!.GetErrorMsg(ret));
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    var mLastDttTime = 0L
    override fun OnDeviceDetached() {
        try {
            if (SystemClock.elapsedRealtime() - mLastDttTime < 1500) {
                return
            }
            mLastDttTime = SystemClock.elapsedRealtime()
            unInitScanner()
            Log.e("Device removed", "")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun OnHostCheckFailed(err: String?) {
        try {
            Log.e("Error", err!!)
            //Toast.makeText(applicationContext, err, Toast.LENGTH_LONG).show()
        } catch (ignored: java.lang.Exception) {
        }
    }
}
