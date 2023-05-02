public struct State {
    var a: SIMD4<UInt32> = [0x61707865, 0x3320646e, 0x79622d32, 0x6b206574]
    var b: SIMD4<UInt32>
    var c: SIMD4<UInt32>
    var d: SIMD4<UInt32>
    
    public init(key: SIMD8<UInt32>, nonce: UInt64) {
        b = key.lowHalf
        c = key.highHalf
        d = SIMD4(lowHalf: .zero, highHalf: Swift.withUnsafeBytes(of: nonce, SIMD2.init))
    }
    
    public init(key: some Collection<UInt8>, nonce: some Sequence<UInt8>) {
        b = SIMD4<UInt32>(key.prefix(16))
        c = SIMD4<UInt32>(key.dropFirst(16))
        d = SIMD4(lowHalf: .zero, highHalf: SIMD2(nonce))
    }
    
    public func permuted(rounds: Int) -> WorkingState {
        assert([8, 12, 20].contains(rounds))
        
        var workingState = WorkingState(self)
        
        for _ in stride(from: 0, to: rounds, by: 2) {
            workingState.doubleRound()
        }
        
        workingState &+= self
        
        return workingState
    }
    
    public mutating func incrementCounter() {
        d[0] &+= 1
        if d[0] == 0 {
            d[1] += 1
        }
    }
}

extension SIMD2<UInt32> {
    @inline(__always)
    fileprivate init(_ sequence: some Sequence<UInt8>) {
        self = unsafeBitCast(SIMD8<UInt8>(sequence), to: Self.self)
    }
}

extension SIMD4<UInt32> {
    @inline(__always)
    fileprivate init(_ sequence: some Sequence<UInt8>) {
        self = unsafeBitCast(SIMD16<UInt8>(sequence), to: Self.self)
    }
}

#if _endian(big)
#error("Big-endian platforms are currently not supported")
#endif
