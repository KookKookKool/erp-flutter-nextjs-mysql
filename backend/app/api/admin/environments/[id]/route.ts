import { NextRequest, NextResponse } from 'next/server';

// PATCH /api/admin/environments/[id] - อัปเดต environment status
export async function PATCH(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const body = await request.json();
    const { isActive } = body;
    const { id } = params;

    // สำหรับตอนนี้ให้ return success response
    // ในอนาคตจะอัปเดต database จริง
    return NextResponse.json({
      success: true,
      message: `Environment ${id} ${isActive ? 'activated' : 'deactivated'} successfully`,
    });
  } catch (error) {
    console.error('Error updating environment:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to update environment' },
      { status: 500 }
    );
  }
}

// DELETE /api/admin/environments/[id] - ลบ environment
export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const { id } = params;

    // สำหรับตอนนี้ให้ return success response
    // ในอนาคตจะลบจาก database จริง
    return NextResponse.json({
      success: true,
      message: `Environment ${id} deleted successfully`,
    });
  } catch (error) {
    console.error('Error deleting environment:', error);
    return NextResponse.json(
      { success: false, message: 'Failed to delete environment' },
      { status: 500 }
    );
  }
}
