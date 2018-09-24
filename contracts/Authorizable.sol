pragma solidity ^0.4.18;

contract Authorizable {
    mapping(address => bool) authorizers;

    modifier onlyAuthorized {
        require(isAuthorized(msg.sender));
        _;
    }

    function Authorizable() public {
        authorizers[msg.sender] = true;
    }


    function isAuthorized(address _addr) public constant returns(bool) {
        require(_addr != address(0));

        bool result = bool(authorizers[_addr]);
        return result;
    }

    function addAuthorized(address _addr) external onlyAuthorized {
        require(_addr != address(0));

        authorizers[_addr] = true;
    }

    function delAuthorized(address _addr) external onlyAuthorized {
        require(_addr != address(0));
        require(_addr != msg.sender);

        //authorizers[_addr] = false;
        delete authorizers[_addr];
    }
}
