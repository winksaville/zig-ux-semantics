// Test ux-symantics

const std = @import("std");
const assert = std.debug.assert;
const warn = std.debug.warn;
const builtin = @import("builtin");
const TypeId = builtin.TypeId;

/// Compiler Seg faults:
/// #0  0x00007f4479d32bf0 in llvm::Value::getContext() const () from /usr/lib/libLLVM-6.0.so
/// #1  0x00007f4479cd07f0 in llvm::SwitchInst::SwitchInst(llvm::Value*, llvm::BasicBlock*, unsigned int, llvm::Instruction*) () from /usr/lib/libLLVM-6.0.so
/// #2  0x00007f4479c61845 in LLVMBuildSwitch () from /usr/lib/libLLVM-6.0.so
/// #3  0x000055e869c63221 in ir_render_switch_br (g=0x55e86ad49660, executable=0x55e86adbe0f0, instruction=0x55e86afb4380) at ../src/codegen.cpp:3872
/// #4  0x000055e869c68ef8 in ir_render_instruction (g=0x55e86ad49660, executable=0x55e86adbe0f0, instruction=0x55e86afb4380) at ../src/codegen.cpp:5245
/// #5  0x000055e869c696d1 in ir_render (g=0x55e86ad49660, fn_entry=0x55e86adbdf90) at ../src/codegen.cpp:5380
/// #6  0x000055e869c6db70 in do_code_gen (g=0x55e86ad49660) at ../src/codegen.cpp:6376
/// #7  0x000055e869c7441d in codegen_build_and_link (g=0x55e86ad49660) at ../src/codegen.cpp:8229
/// #8  0x000055e869ce5739 in main (argc=4, argv=0x7fffdaaa5ee8) at ../src/main.cpp:972
//test "undefined.u0" {
//    var val: u0 = undefined;
//    switch (val) {
//        0 => assert(val == 0),
//    }
//}

/// Compiles but fails test with a debug build, works with fast|small|safe builds
///
/// $ zig test ux-semantics.zig 
/// Test 1/12 undefined.u1.truncate...assertion failure
/// /home/wink/opt/lib/zig/std/debug/index.zig:118:13: 0x205029 in ??? (test)
///             @panic("assertion failure");
///             ^
/// /home/wink/prgs/ziglang/zig-ux-semantics/ux-semantics.zig:59:20: 0x20507d in ??? (test)
///         1 => assert(val == 1),
///                    ^
/// /home/wink/opt/lib/zig/std/special/test_runner.zig:13:25: 0x22330a in ??? (test)
///         if (test_fn.func()) |_| {
///                         ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:96:22: 0x2230bb in ??? (test)
///             root.main() catch |err| {
///                      ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:70:20: 0x223035 in ??? (test)
///     return callMain();
///                    ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:64:39: 0x222e98 in ??? (test)
///     std.os.posix.exit(callMainWithArgs(argc, argv, envp));
///                                       ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:37:5: 0x222d50 in ??? (test)
///     @noInlineCall(posixCallMainAndExit);
///     ^
/// 
/// Tests failed. Use the following command to reproduce the failure:
/// /home/wink/prgs/ziglang/zig-ux-semantics/zig-cache/test
//test "undefined.u1.truncate" {
//    var val: u1 = undefined;
//    val = @truncate(u1, val);
//    switch (val) {
//        0 => assert(val == 0),
//        1 => assert(val == 1),
//    }
//}

/// Compiles but fails test with a debug build, works with fast|small|safe builds
///
/// $ zig test ux-semantics.zig 
/// Test 1/10 undefined.u1.truncate.assert.truncate...assertion failure
/// /home/wink/opt/lib/zig/std/debug/index.zig:96:13: 0x205029 in ??? (test)
///             @panic("assertion failure");
///             ^
/// /home/wink/prgs/ziglang/zig-ux-semantics/ux-semantics.zig:96:20: 0x20507d in ??? (test)
///         1 => assert(@truncate(u1, val) == 1),
///                    ^
/// /home/wink/opt/lib/zig/std/special/test_runner.zig:13:25: 0x22324a in ??? (test)
///         if (test_fn.func()) |_| {
///                         ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:96:22: 0x222ffb in ??? (test)
///             root.main() catch |err| {
///                      ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:70:20: 0x222f75 in ??? (test)
///     return callMain();
///                    ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:64:39: 0x222dd8 in ??? (test)
///     std.os.posix.exit(callMainWithArgs(argc, argv, envp));
///                                       ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:37:5: 0x222c90 in ??? (test)
///     @noInlineCall(posixCallMainAndExit);
///     ^
/// 
/// Tests failed. Use the following command to reproduce the failure:
/// /home/wink/prgs/ziglang/zig-ux-semantics/zig-cache/test
//test "undefined.u1.truncate.assert.truncate" {
//    var val: u1 = undefined;
//    val = @truncate(u1, val);
//    switch (val) {
//        0 => assert(val == 0),
//        1 => assert(@truncate(u1, val) == 1),
//    }
//}

/// Compiles but fails test with a debug build, works with fast|small|safe builds
///
/// $ zig test ux-semantics.zig 
/// Test 1/11 undefined.u1.bitmask...assertion failure
/// /home/wink/opt/lib/zig/std/debug/index.zig:133:13: 0x205029 in ??? (test)
///             @panic("assertion failure");
///             ^
/// /home/wink/prgs/ziglang/zig-ux-semantics/ux-semantics.zig:133:20: 0x20507d in ??? (test)
///         1 => assert(val == 1),
///                    ^
/// /home/wink/opt/lib/zig/std/special/test_runner.zig:13:25: 0x2232aa in ??? (test)
///         if (test_fn.func()) |_| {
///                         ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:96:22: 0x22305b in ??? (test)
///             root.main() catch |err| {
///                      ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:70:20: 0x222fd5 in ??? (test)
///     return callMain();
///                    ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:64:39: 0x222e38 in ??? (test)
///     std.os.posix.exit(callMainWithArgs(argc, argv, envp));
///                                       ^
/// /home/wink/opt/lib/zig/std/special/bootstrap.zig:37:5: 0x222cf0 in ??? (test)
///     @noInlineCall(posixCallMainAndExit);
///     ^
/// 
/// Tests failed. Use the following command to reproduce the failure:
/// /home/wink/prgs/ziglang/zig-ux-semantics/zig-cache/test
//test "undefined.u1.bitmask" {
//    var val: u1 = undefined;
//    val &= 1;
//    switch (val) {
//        0 => assert(val == 0),
//        1 => assert(val == 1),
//    }
//}

test "undefined.u1.assert.truncate" {
    var val: u1 = undefined;
    switch (val) {
        0 => assert(val == 0),
        else => assert(@truncate(u1, val) == 1),
    }
}

test "assignment.u0" {
    var val: u0 = 0;
    assert(val == 0);

    // val = 1;         // Expected an error, got error: integer value 1 cannot be implicitly casted to type 'u0'.
                      // It seems possible this could be done via some
                      // unsafe cast or call to a external function,
    assert(val == 0); // but if it did the result read back must always 0.
}

test "assignment.u1" {
    var val: u1 = 0;
    assert(val == 0);

    val = 1;
    assert(val == 1);
}

test "sizeof.u0" {
    assert(@sizeOf(u0) == 0);
    var val: u0 = 0;
    assert(@sizeOf(@typeOf(val)) == 0);
}

test "sizeof.u1" {
    assert(@sizeOf(u1) == 1);
    var val: u1 = 1;
    assert(@sizeOf(@typeOf(val)) == 1);
}

test "intCast.u0" {
    var val: u0 = 0;
    assert(@intCast(u8, val) == 0);
}

test "intCast.u1" {
    var val: u1 = 1;
    assert(@intCast(u8, val) == 1);
}

test "address.u0" {
    var val: u0 = 0;
    assert(val == 0);
    var pVal = &val;
    assert(pVal == &val);
    assert(pVal.* == 0);
    pVal.* = 0;
    assert(val == 0);
    assert(pVal.* == 0);
}

test "address.u1" {
    var val: u1 = 0;
    assert(val == 0);
    var pVal = &val;
    assert(pVal == &val);
    assert(pVal.* == 0);
    pVal.* = 1;
    assert(val == 1);
    assert(pVal.* == 1);
}

fn S1field(comptime T1: type) type {
    return struct {
        f1: T1,
    };
}

test "struct.S1field.u8" {
    const S1f = S1field(u8);
    var s1f = S1f { .f1 = 0,};
    assert(s1f.f1 == 0);
    assert(@sizeOf(S1f) == 1);
    assert(@offsetOf(S1f, "f1") == 0);
}

/// Compile fails
///
/// $ zig test ux-semantics.zig 
/// /home/wink/prgs/ziglang/zig-ux-semantics/ux-semantics.zig:226:27: error: zero-bit field 'f1' in struct 'S1field(u0)' has no offset
///     assert(@offsetOf(S1f, "f1") == 0); // error: zero-bit field ...
///                           ^
//test "struct.S1field.u0" {
//    const S1f = S1field(u0);
//    var s1f = S1f { .f1 = 0,};
//    assert(s1f.f1 == 0);
//    assert(@sizeOf(S1f) == 0);
//    assert(@offsetOf(S1f, "f1") == 0); // error: zero-bit field ...
//}
