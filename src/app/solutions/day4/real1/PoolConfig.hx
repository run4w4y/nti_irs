package app.solutions.day4.real1;

import connectionPool.PoolMember;
import app.solutions.day4.real1.Watcher;


class PoolConfig {
    public static var master = new PoolMember(10, '192.168.77.1');
    public static var slave = new PoolMember(20);
    public static var watcher:Watcher;
}