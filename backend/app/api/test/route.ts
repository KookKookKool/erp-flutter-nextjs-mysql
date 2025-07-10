import { NextRequest, NextResponse } from 'next/server';

// Add CORS headers
function addCorsHeaders(response: NextResponse) {
  response.headers.set('Access-Control-Allow-Origin', '*')
  response.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  response.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization, Accept')
  response.headers.set('Access-Control-Max-Age', '86400')
  return response
}

export async function OPTIONS(request: NextRequest) {
  const response = new NextResponse(null, { status: 200 })
  return addCorsHeaders(response)
}

export async function GET(req: NextRequest) {
  try {
    const response = NextResponse.json({
      message: 'Server is running successfully!',
      timestamp: new Date().toISOString(),
      status: 'OK'
    }, { status: 200 });
    return addCorsHeaders(response)
  } catch (error) {
    console.error('Test endpoint error:', error);
    const response = NextResponse.json({
      error: 'Test endpoint failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 });
    return addCorsHeaders(response)
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const response = NextResponse.json({
      message: 'POST test successful!',
      receivedData: body,
      timestamp: new Date().toISOString(),
      status: 'OK'
    }, { status: 200 });
    return addCorsHeaders(response)
  } catch (error) {
    console.error('Test POST endpoint error:', error);
    const response = NextResponse.json({
      error: 'Test POST endpoint failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500 });
    return addCorsHeaders(response)
  }
}
