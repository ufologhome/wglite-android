import os
from tunloop import udp_sock

def udp_loop(tun_fd):
    while True:
        data, _ = udp_sock.recvfrom(2048)
        os.write(tun_fd, data)
