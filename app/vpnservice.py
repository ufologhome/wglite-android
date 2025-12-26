import os
import threading
from jnius import autoclass, PythonJavaClass, java_method

VpnService = autoclass('android.net.VpnService')
ParcelFileDescriptor = autoclass('android.os.ParcelFileDescriptor')

SERVER_IP = "192.168.0.150"
SERVER_PORT = 51820

class MyVpnService(PythonJavaClass):
    __javabase__ = 'android/net/VpnService'

    def __init__(self):
        super().__init__()
        self.tun_fd = None

    @java_method('()V')
    def onCreate(self):
        builder = self.Builder()
        builder.addAddress("10.0.0.2", 32)
        builder.addRoute("0.0.0.0", 0)
        builder.setMtu(1400)

        pfd = builder.establish()
        self.tun_fd = pfd.detachFd()

        from tunloop import tun_loop
        from udploop import udp_loop

        threading.Thread(
            target=tun_loop,
            args=(self.tun_fd, SERVER_IP, SERVER_PORT),
            daemon=True
        ).start()

        threading.Thread(
            target=udp_loop,
            args=(self.tun_fd,),
            daemon=True
        ).start()
