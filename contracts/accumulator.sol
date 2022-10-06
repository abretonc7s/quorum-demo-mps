// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract accumulator {
    uint public storedData;

    event IncEvent(uint value);

    constructor(uint initVal) {
        storedData = initVal;
    }

    function inc(uint x) public {
        storedData = storedData + x;
        emit IncEvent(storedData);
    }

    function get() view public returns (uint retVal) {
        return storedData;
    }
}
