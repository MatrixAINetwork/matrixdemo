pragma solidity >=0.4.17;
library  manUtils {
    /* Converts given number to base58, limited by _maxLength symbols */
    function toMan(address _addr)  public pure returns (string memory) {
        uint256 _value = uint256(_addr);
        bytes memory _bytevalue = new bytes(20);
        assembly { mstore(add(_bytevalue, 20), _value) }
        string memory currency = "MAN";
        string memory letters = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
        bytes memory alphabet = bytes(letters);
        uint8 len = 0;
        uint256 remainder = 0;
        bool needBreak = false;
        bytes memory bytesReversed = bytes(new string(30));
        uint8 i = 0;

        for (i = 0; i < 30; i++) {
            if(_value < 58){
                needBreak = true;
            }
            remainder = _value % 58;
            _value = uint256(_value / 58);
            bytesReversed[i] = alphabet[remainder];
            len++;
            if(needBreak){
                break;
            }
        }

        uint numzero;
        for (numzero = 0; numzero < _bytevalue.length; numzero++) {
            if(_bytevalue[numzero] != 0x00) {
                break;
            }
        }

        // Reverse
        uint it = numzero;
        bytes memory currencybyte = bytes(currency);
        bytes memory result = bytes(new string(len + numzero + currencybyte.length + 2));
        for (i = 0 ; i < result.length -1; i++) {
            if(i > currencybyte.length){
                if(it > 0){
                    it--;
                    result[i] = alphabet[0];
                }
                else
                    result[i] = bytesReversed[len - (i - numzero - currencybyte.length)];
            }
            else if(i< currencybyte.length)
                result[i] = currencybyte[i];
            else if(i == currencybyte.length )
                result[i] = '.';
        }
        result[i] = alphabet[uint8(crc8(string(result), uint(result.length-1))) % 58];

        return string(result);
    }

    function toAddress(string memory _manAddr) public pure returns(address) {
        bytes memory _prefix = bytes(_manAddr);
        uint8[74] memory unbase58 = [
        0, 1, 2, 3, 4, 5, 6,
        7, 8, 255, 255, 255, 255, 255, 255,
        255, 9, 10, 11, 12, 13, 14, 15,
        16, 255, 17, 18, 19, 20, 21, 255,
        22, 23, 24, 25, 26, 27, 28, 29,
        30, 31, 32, 255, 255, 255, 255, 255,
        255, 33, 34, 35, 36, 37, 38, 39,
        40, 41, 42, 43, 255, 44, 45, 46,
        47, 48, 49, 50, 51, 52, 53, 54,
        55, 56, 57
        ];

        uint256 prefixValue = 0;
        uint256 prefix1 = 1;
        uint256 scratch = 0;
        uint8 tmp = 0;

        for (uint i = _prefix.length-1; i >0 ; i--) {
            if(_prefix[i-1] == '.')
                break;
            uint8 index = uint8(_prefix[i-1]);
            require(index > 48);
            require(index < 123);
            index -= 49;
            tmp = unbase58[index];
            require(tmp != 255);
            scratch = tmp;
            scratch = scratch * prefix1;
            prefixValue += scratch;
            prefix1 *= 58;
        }
        return address(prefixValue);
    }

    /* Concatenates two strings */

    function crc8(string memory addr,uint len) private pure returns (byte){
        bytes memory b = bytes(addr);
        uint8[256] memory checksum_table = [
        0x00, 0x07, 0x0E, 0x09, 0x1C, 0x1B, 0x12, 0x15, 0x38, 0x3F, 0x36, 0x31, 0x24, 0x23, 0x2A, 0x2D,
        0x70, 0x77, 0x7E, 0x79, 0x6C, 0x6B, 0x62, 0x65, 0x48, 0x4F, 0x46, 0x41, 0x54, 0x53, 0x5A, 0x5D,
        0xE0, 0xE7, 0xEE, 0xE9, 0xFC, 0xFB, 0xF2, 0xF5, 0xD8, 0xDF, 0xD6, 0xD1, 0xC4, 0xC3, 0xCA, 0xCD,
        0x90, 0x97, 0x9E, 0x99, 0x8C, 0x8B, 0x82, 0x85, 0xA8, 0xAF, 0xA6, 0xA1, 0xB4, 0xB3, 0xBA, 0xBD,
        0xC7, 0xC0, 0xC9, 0xCE, 0xDB, 0xDC, 0xD5, 0xD2, 0xFF, 0xF8, 0xF1, 0xF6, 0xE3, 0xE4, 0xED, 0xEA,
        0xB7, 0xB0, 0xB9, 0xBE, 0xAB, 0xAC, 0xA5, 0xA2, 0x8F, 0x88, 0x81, 0x86, 0x93, 0x94, 0x9D, 0x9A,
        0x27, 0x20, 0x29, 0x2E, 0x3B, 0x3C, 0x35, 0x32, 0x1F, 0x18, 0x11, 0x16, 0x03, 0x04, 0x0D, 0x0A,
        0x57, 0x50, 0x59, 0x5E, 0x4B, 0x4C, 0x45, 0x42, 0x6F, 0x68, 0x61, 0x66, 0x73, 0x74, 0x7D, 0x7A,
        0x89, 0x8E, 0x87, 0x80, 0x95, 0x92, 0x9B, 0x9C, 0xB1, 0xB6, 0xBF, 0xB8, 0xAD, 0xAA, 0xA3, 0xA4,
        0xF9, 0xFE, 0xF7, 0xF0, 0xE5, 0xE2, 0xEB, 0xEC, 0xC1, 0xC6, 0xCF, 0xC8, 0xDD, 0xDA, 0xD3, 0xD4,
        0x69, 0x6E, 0x67, 0x60, 0x75, 0x72, 0x7B, 0x7C, 0x51, 0x56, 0x5F, 0x58, 0x4D, 0x4A, 0x43, 0x44,
        0x19, 0x1E, 0x17, 0x10, 0x05, 0x02, 0x0B, 0x0C, 0x21, 0x26, 0x2F, 0x28, 0x3D, 0x3A, 0x33, 0x34,
        0x4E, 0x49, 0x40, 0x47, 0x52, 0x55, 0x5C, 0x5B, 0x76, 0x71, 0x78, 0x7F, 0x6A, 0x6D, 0x64, 0x63,
        0x3E, 0x39, 0x30, 0x37, 0x22, 0x25, 0x2C, 0x2B, 0x06, 0x01, 0x08, 0x0F, 0x1A, 0x1D, 0x14, 0x13,
        0xAE, 0xA9, 0xA0, 0xA7, 0xB2, 0xB5, 0xBC, 0xBB, 0x96, 0x91, 0x98, 0x9F, 0x8A, 0x8D, 0x84, 0x83,
        0xDE, 0xD9, 0xD0, 0xD7, 0xC2, 0xC5, 0xCC, 0xCB, 0xE6, 0xE1, 0xE8, 0xEF, 0xFA, 0xFD, 0xF4, 0xF3];
        byte result=0x00;
        for (uint i = 0; i < len; i++) {
            result = byte(checksum_table[uint8((result ^ (b[i] & 0xFF) ) & 0xFF)]);
        }
        return (byte) (result & 0xFF);
    }
}