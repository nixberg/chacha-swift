public struct WorkingState {
    private var a: SIMD4<UInt32>
    private var b: SIMD4<UInt32>
    private var c: SIMD4<UInt32>
    private var d: SIMD4<UInt32>
    
    @inline(__always)
    static func &+= (lhs: inout Self, rhs: State) {
        lhs.a &+= rhs.a
        lhs.b &+= rhs.b
        lhs.c &+= rhs.c
        lhs.d &+= rhs.d
    }
    
    @inline(__always)
    init(_ state: State) {
        self.a = state.a
        self.b = state.b
        self.c = state.c
        self.d = state.d
    }
    
    @inline(__always)
    mutating func doubleRound() {
        self.round()
        self.diagonalize()
        self.round()
        self.undiagonalize()
    }
    
    @inline(__always)
    private mutating func round() {
        a &+= b
        d ^= a
        d.rotate(left: 16)
        
        c &+= d
        b ^= c
        b.rotate(left: 12)
        
        a &+= b
        d ^= a
        d.rotate(left: 08)
        
        c &+= d
        b ^= c
        b.rotate(left: 07)
    }
    
    @inline(__always)
    private mutating func diagonalize() {
    //  a = a[0, 1, 2, 3]
        b = b[1, 2, 3, 0]
        c = c[2, 3, 0, 1]
        d = d[3, 0, 1, 2]
    }
    
    @inline(__always)
    private mutating func undiagonalize() {
    //  a = a[0, 1, 2, 3]
        b = b[3, 0, 1, 2]
        c = c[2, 3, 0, 1]
        d = d[1, 2, 3, 0]
    }
}

extension SIMD4<UInt32> {
    @inline(__always)
    fileprivate subscript(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar) -> Self {
        self[Self(v0, v1, v2, v3)]
    }
    
    @inline(__always)
    fileprivate mutating func rotate(left count: Scalar) {
        self = self &<< count | self &>> (32 - count)
    }
}
