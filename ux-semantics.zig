// Test ux-symantics

const std = @import("std");
const assert = std.debug.assert;
const warn = std.debug.warn;
const builtin = @import("builtin");
const TypeId = builtin.TypeId;
const Timer = std.os.time.Timer;
const DefaultPrng = std.rand.DefaultPrng;

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

var once: bool = false;
var prng: DefaultPrng = undefined;

fn seed() u64 {
    var timer = Timer.start() catch return 123;
    return timer.read();
}

fn rand() u64 {
    if (!once) {
        once = true;
        prng = DefaultPrng.init(seed());
    }
    return prng.random.scalar(u64);
}

/// $ zig test ux-semantics.zig 
/// Trunc only produces integer
///   trunc i64 %3 to void, !dbg !780
/// LLVM ERROR: Broken module found, compilation aborted!
//test "undefined.u0.truncate.u0.rand.FAILS" {
//    var i: u8 = 32;
//    while (i > 0) : (i -= 1) {
//        var val: u0 = undefined;
//        val = @truncate(u0, rand());
//        assert(val == 0);
//    }
//}

test "undefined.u0.truncate.u0.literal.OK" {
    var i: u8 = 32;
    while (i > 0) : (i -= 1) {
        var val: u0 = undefined;
        val = @truncate(u0, 123);
        assert(val == 0);
    }
}

test "undefined.u1" {
    var i: u8 = 32;
    while (i > 0) : (i -= 1) {
        var val: u1 = undefined;
        val = @truncate(u1, rand());
        switch (val) {
            0 => assert(val == 0),
            1 => assert(val == 1),
        }
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

/// Compile fails, see https://github.com/ziglang/zig/issues/1564
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

fn displayF1ValOffsetAddr(s1: var) void {
    warn("s1.f1={} offset(s1.f1)={} &s1.f1={*}\n",
        s1.f1, @intCast(usize, @offsetOf(@typeOf(s1), "f1")), &s1.f1);
}

test "displayF1ValOffsetAddr.u1" {
    warn("\n");
    const S1f = S1field(u1);
    var s1f = S1f { .f1 = 0,};
    displayF1ValOffsetAddr(s1f);
}

test "displayF1ValOffsetAddr.i128" {
    warn("\n");
    const S1f = S1field(i128);
    var s1f = S1f { .f1 = 0,};
    displayF1ValOffsetAddr(s1f);
}

/// Compile fails, same error as test "struct.S1field.u0"
///
/// /home/wink/prgs/ziglang/zig-ux-semantics/ux-semantics.zig:170:55: error: zero-bit field 'f1' in struct 'S1field(u0)' has no offset
///         s1.f1, @intCast(usize, @offsetOf(@typeOf(s1), "f1")), &s1.f1);
///                                                       ^
/// /home/wink/prgs/ziglang/zig-ux-semantics/ux-semantics.zig:198:27: note: called from here
///     displayF1ValOffsetAddr(s1f);
///                           ^
//test "displayF1ValOffsetAddr.u0" {
//    const S1f = S1field(u0);
//    var s1f = S1f { .f1 = 0,};
//    displayF1ValOffsetAddr(s1f);
//}
