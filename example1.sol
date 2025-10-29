pragma solidity ^0.8.26;

contract Calculator {
    uint public result;

    function add(uint a, uint b) public pure virtual returns (uint) {
        return a + b;
    }

    function store(uint value) public {
        result = value; // modifies state → not view or pure
    }

    function getResult() public view returns (uint) {
        return result; // reads state
    }
}

contract AdvancedCalculator is Calculator {
    function add(uint a, uint b) public pure override returns (uint) {
        return a + b + 1; // modifies parent behavior
    }
}