const std = @import("std");
const assert = std.debug.assert;

test "truncate.u0.literal" {
    var z = @truncate(u0, 0);
    assert(z == 0);
}

test "truncate.u0.const" {
    const c0: usize = 0;
    var z = @truncate(u0, c0);
    assert(z == 0);
}

/// Compile error:
///
/// $ zig test truncate-u0.zig 
/// Trunc only produces integer
///   trunc i8 %1 to void, !dbg !654
/// LLVM ERROR: Broken module found, compilation aborted!
test "truncate.u0.var" {
    var d: u8 = 2;
    var z = @truncate(u0, d);
    assert(z == 0);
}
