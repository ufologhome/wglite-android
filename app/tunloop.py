import os
import socket

udp_sock = None

def tun_loop(tun_fd, server_ip, server_port):
    global udp_sock
    udp_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    while True:
        data = os.read(tun_fd, 2048)
        if not data:
            continue
        udp_sock.sendto(data, (server_ip, server_port))
