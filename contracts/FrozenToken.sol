pragma solidity ^0.4.18;

import "./StandardToken.sol";
import "./Ownable.sol";

contract FrozenToken is StandardToken, Ownable {
    mapping(address => bool) frozens;
    mapping(address => uint256) frozenTokens;

    event FrozenAddress(address addr);
    event UnFrozenAddress(address addr);
    event FrozenTokenEvent(address addr, uint256 amount);
    event UnFrozenTokenEvent(address addr, uint256 amount);

    modifier isNotFrozen() {
        require(frozens[msg.sender] == false);
        _;
    }

    function frozenAddress(address _addr) onlyOwner public returns (bool) {
        require(_addr != address(0));

        frozens[_addr] = true;
        FrozenAddress(_addr);
        return frozens[_addr];
    }

    function unFrozenAddress(address _addr) onlyOwner public returns (bool) {
        require(_addr != address(0));

        delete frozens[_addr];
        //frozens[_addr] = false;
        UnFrozenAddress(_addr);
        return frozens[_addr];
    }

    function isFrozenByAddress(address _addr) public constant returns(bool) {
        require(_addr != address(0));

        bool result = bool(frozens[_addr]);
        return result;
    }

    function balanceFrozenTokens(address _addr) public constant returns(uint256) {
        require(_addr != address(0));

        uint256 result = uint256(frozenTokens[_addr]);
        return result;
    }

    function balanceAvailableTokens(address _addr) public constant returns(uint256) {
        require(_addr != address(0));

        uint256 frozen = uint256(frozenTokens[_addr]);
        uint256 balance = uint256(balances[_addr]);
        require(balance >= frozen);

        uint256 result = balance.sub(frozen);

        return result;
    }

    function frozenToken(address _addr, uint256 _amount) onlyOwner public returns(bool) {
        require(_addr != address(0));
        require(_amount > 0);

        uint256 balance = uint256(balances[_addr]);
        require(balance >= _amount);

        frozenTokens[_addr] = frozenTokens[_addr].add(_amount);
        FrozenTokenEvent(_addr, _amount);
        return true;
    }


    function unFrozenToken(address _addr, uint256 _amount) onlyOwner public returns(bool) {
        require(_addr != address(0));
        require(_amount > 0);
        require(frozenTokens[_addr] >= _amount);

        frozenTokens[_addr] = frozenTokens[_addr].sub(_amount);
        UnFrozenTokenEvent(_addr, _amount);
        return true;
    }

    function transfer(address _to, uint256 _value) isNotFrozen() public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        uint256 balance = balances[msg.sender];
        uint256 frozen = frozenTokens[msg.sender];
        uint256 availableBalance = balance.sub(frozen);
        require(availableBalance >= _value);

        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) isNotFrozen() public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        uint256 balance = balances[_from];
        uint256 frozen = frozenTokens[_from];
        uint256 availableBalance = balance.sub(frozen);
        require(availableBalance >= _value);

        return super.transferFrom(_from ,_to, _value);
    }
}