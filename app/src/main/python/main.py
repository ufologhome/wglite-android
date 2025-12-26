from jnius import autoclass
from android import activity

PythonActivity = autoclass('org.kivy.android.PythonActivity')
VpnService = autoclass('android.net.VpnService')
Intent = autoclass('android.content.Intent')

def start_vpn():
    activity_ctx = PythonActivity.mActivity
    intent = VpnService.prepare(activity_ctx)
    if intent:
        activity_ctx.startActivityForResult(intent, 0)
    else:
        start_service()

def start_service():
    ctx = PythonActivity.mActivity
    svc_intent = Intent(ctx, autoclass('org.kivy.android.PythonService'))
    svc_intent.putExtra("serviceClass", "vpnservice.MyVpnService")
    ctx.startService(svc_intent)

if __name__ == "__main__":
    start_vpn()
