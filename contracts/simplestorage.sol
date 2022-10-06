// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract simplestorage {
  uint public storedData;

  constructor(uint initVal) {
    storedData = initVal;
  }

  function set(uint x) public {
    storedData = x;
  }

  function get() view public returns (uint retVal) {
    return storedData;
  }
}
