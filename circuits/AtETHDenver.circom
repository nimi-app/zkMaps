pragma circom 2.0.0;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

// This contract verifies that you're in denver
template AtETHDenver() {
    // Your private coordinates
    signal input latitude;
    signal input longitude;
    signal output o; // necessary to compile as per https://github.com/iden3/snarkjs/issues/116#issuecomment-1020352690
    o <== 1;

    // Public definition of ethdenver
    // 4 city blocks, starting in the north east, going counter-clockwise
    // 12th and Lincoln
    var northEastLatitude = 12973547807205027;
    var northEastLongitude = 7501387182542445;

    // 10th and Bancock
    var southWestLatitude = 12973227978507761;
    var southWestLongitude = 7500977777251778;

    // latitude < northEastLatitude;
    component lt1 = LessThan(64);
    lt1.in[0] <== latitude;
    lt1.in[1] <== northEastLatitude;
    lt1.out === 1;

    // longitude < northEastLongitude;
    component lt2 = LessThan(64);
    lt2.in[0] <== longitude;
    lt2.in[1] <== northEastLongitude;
    lt2.out === 1;

    // latitude > southWestLatitude;
    component lt3 = LessThan(64);
    lt3.in[0] <== southWestLatitude;
    lt3.in[1] <== latitude;
    lt3.out === 1;

    // longitude > southWestLatitude;
    component lt4 = LessThan(64);
    lt4.in[0] <== southWestLongitude;
    lt4.in[1] <== longitude;
    lt4.out === 1;
}

component main = AtETHDenver();