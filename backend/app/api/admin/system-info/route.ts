import { NextResponse } from 'next/server';
import os from 'os';

export async function GET() {
  try {
    const nodeVersion = process.version;
    const platform = `${os.type()} ${os.release()} ${os.arch()}`;
    const environment = process.env.NODE_ENV || 'development';
    
    // Calculate uptime
    const uptimeSeconds = process.uptime();
    const days = Math.floor(uptimeSeconds / 86400);
    const hours = Math.floor((uptimeSeconds % 86400) / 3600);
    const minutes = Math.floor((uptimeSeconds % 3600) / 60);
    const uptime = `${days}d ${hours}h ${minutes}m`;
    
    // Calculate memory usage
    const memoryUsage = process.memoryUsage();
    const memoryMB = Math.round(memoryUsage.rss / 1024 / 1024);
    const memory = `${memoryMB} MB`;

    return NextResponse.json({
      nodeVersion,
      platform,
      environment,
      uptime,
      memory,
      pid: process.pid,
      cpus: os.cpus().length,
      totalMemory: `${Math.round(os.totalmem() / 1024 / 1024 / 1024)} GB`,
      freeMemory: `${Math.round(os.freemem() / 1024 / 1024 / 1024)} GB`,
    });
  } catch (error) {
    console.error('Error fetching system info:', error);
    return NextResponse.json(
      { message: 'Failed to fetch system information' },
      { status: 500 }
    );
  }
}
