# Semantics of ux where ux is u0, u1 ... uN.

This is just a start and there are 8 passing tests.
The two undefined.u0/u1 tests are commented out as
they are currently failing when I don't feel they
should.

# Test
```
$ zig test ux-semantics.zig 
Test 1/8 assignment.u0...OK
Test 2/8 assignment.u1...OK
Test 3/8 sizeof.u0...OK
Test 4/8 sizeof.u1...OK
Test 5/8 intCast.u0...OK
Test 6/8 intCast.u1...OK
Test 7/8 address.u0...OK
Test 8/8 address.u1...OK
All tests passed.
```
