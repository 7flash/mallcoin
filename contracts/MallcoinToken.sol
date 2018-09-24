pragma solidity ^0.4.18;

import "./FrozenToken.sol";
import "./Authorizable.sol";

contract MallcoinToken is FrozenToken, Authorizable {
    string public constant name = "Mallcoin Token";
    string public constant symbol = "MLC";
    uint8 public constant decimals = 18;
    uint256 public MAX_TOKEN_SUPPLY = 250000000 * 1 ether;

    event CreateToken(address indexed to, uint256 amount);
    event CreateTokenByAtes(address indexed to, uint256 amount, string data);

    modifier onlyOwnerOrAuthorized {
        require(msg.sender == owner || isAuthorized(msg.sender));
        _;
    }

    function createToken(address _to, uint256 _amount) onlyOwnerOrAuthorized public returns (bool) {
        require(_to != address(0));
        require(_amount > 0);
        require(MAX_TOKEN_SUPPLY >= totalSupply_ + _amount);

        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);

        // KYC
        frozens[_to] = true;
        FrozenAddress(_to);

        CreateToken(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
    }

    function createTokenByAtes(address _to, uint256 _amount, string _data) onlyOwnerOrAuthorized public returns (bool) {
        require(_to != address(0));
        require(_amount > 0);
        require(bytes(_data).length > 0);
        require(MAX_TOKEN_SUPPLY >= totalSupply_ + _amount);

        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);

        // KYC
        frozens[_to] = true;
        FrozenAddress(_to);

        CreateTokenByAtes(_to, _amount, _data);
        Transfer(address(0), _to, _amount);
        return true;
    }
}

