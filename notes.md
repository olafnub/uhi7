https://base-batches-builder-track.devfolio.co/overview

## Initializing projects
1. forge init points-hook
2. forge install https://github.com/Uniswap/v4-periphery
3. forge remappings > remappings.txt
4. rm ./**/Counter*.sol

## Solidity functions
1. View: function only reads blockchain data. Ex: getBalance()
2. pure: neither reads nor writes to blockchain. Ex: A helper function
3. virtual: defines a function to be overriden from child. Ex: A parent Class and child class in java. Virtual would be used in the parent class/file.
4. Override: let's the function do the overriding. Ex: Override would be used in the child class/file.
5. payable: the function can receive Ether. W/o it: address(this).call{value: 1 ether}("") would fail.
6. public: anyone or any contract can call it; external: only outside contracts or users can call it; internal: only this contract or derived contracts can use it; private: only this contract can use it.
7. Example1.Sol brings it all together

## Questions
1. transient storage and Ethereum's cancun
2. What is ERC1155: Guessing it's a LST

